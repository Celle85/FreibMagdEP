#pragma rtGlobals=1		// Use modern global access method.


//	edgDSP
//
//	2010-07-30	the highpass was not implemented
//	2009-08-05	ausgelagert (mb)

//////////////////////////////////
// Trendremoval based on various models
//////////////////////////////////
function DSP_TrendRemoval(theWave)
	Wave theWave
	NVAR gTrendRemovalModel;  variable i, numPoints = numpnts(theWave)
	switch(gTrendRemovalModel)
		case 2:	//"naive"
			variable y1 = (theWave[0]+theWave[1]+theWave[2])/3, y2 = theWave[numPoints-1]
			theWave[] -= y1*(1- p/numPoints) + y2 * p/numPoints
			break
		case 3:	// "line"
			CurveFit /n/q line theWave[1,numPoints-2];  theWave[] -= k0+k1*pnt2x(theWave, p)
			break
		case 4:	// "exp"
			CurveFit /N/Q exp  theWave[1,numPoints-2];  theWave[] -= k0 + k1*exp(-k2*pnt2x(theWave, p))
			break
		default:	// no trend removal
	endswitch
end


function DSP_BandPass01InPlace(waveNameInOut, loCutInHz, hiCutInHz)
	string waveNameInOut
	variable loCutInHz, hiCutInHz
	
	if (strlen(waveNameInOut) < 1)
		return 0
	endif
	duplicate /o $waveNameInOut, DSP_BandPass01InPlaceTempWave99
	DSP_BandPass01(NameOfWave(DSP_BandPass01InPlaceTempWave99), waveNameInOut, loCutInHz, hiCutInHz)
	KillWaves DSP_BandPass01InPlaceTempWave99
end


function DSP_BandPass01(waveNameIn, waveNameOut, loCutInHz, hiCutInHz)
	string waveNameIn, waveNameOut
	variable loCutInHz, hiCutInHz
	
	duplicate /o $waveNameIn, $waveNameOut
	WAVE waveOut = $waveNameOut
	variable nPoints=numpnts(waveOut), wasRedimensioned=0, wasOdd=0, i
	
	// trend removal, otherwise the DFT may add artifactal start and end steps
	// assumption: linear trend
	// trend estimated by averaging over the period of the loCut frequency
	variable periodInSecs = 1.0/hiCutInHz, meanLeft, meanRight
	WaveStats /Q/R=(leftx(waveOut), leftx(waveOut)+periodInSecs) waveOut;  meanLeft = V_avg
	WaveStats /Q/R=(rightx(waveOut)-periodInSecs, rightx(waveOut)) waveOut;  meanRight = V_avg
	variable trendAmplitudePerPoint = (meanRight -meanLeft) / nPoints
	waveOut[] -= p * trendAmplitudePerPoint
	
	// if the lengths is odd, replicate the last point
	if (mod(nPoints, 2) ==1)
		Redimension/N=(nPoints+1) waveOut
		waveOut[nPoints] = waveOut[nPoints-1]
		wasOdd = 1
	endif
	
	// Igor's FFT assumes the wave begins at time 0
	variable originalLeftx = leftx(waveOut)
	SetScale/P x 0, deltax(waveOut), WaveUnits(waveOut, 0), waveOut
	
	// the time series scale needs to be in seconds so the spectrum comes out in Hz
	if (cmpstr(WaveUnits(waveOut, 0), "ms") == 0)
		SetScale/P x leftx(waveOut)/1000, deltax(waveOut)/1000, "s", waveOut
		wasRedimensioned = 1
	endif
		
	// now finally we can transform, null out the spectrum, and transform back
	duplicate /o waveOut, wSpectrum_BandPass_BandPass
	FFT /DEST=wSpectrum_BandPass_BandPass waveOut

	// null out the undesired spectrum
	variable hiCutIndex = x2pnt(wSpectrum_BandPass_BandPass, hiCutInHz)
	variable loCutIndex = x2pnt(wSpectrum_BandPass_BandPass, loCutInHz)
	for (i=hiCutIndex; i<numpnts(wSpectrum_BandPass_BandPass); i+=1)
		wSpectrum_BandPass_BandPass[i] = 0
	endfor
	for (i=0; i<loCutIndex; i+=1)
		wSpectrum_BandPass_BandPass[i] = 0
	endfor
	
	// transform back
	IFFT /DEST=$waveNameOut wSpectrum_BandPass_BandPass
	KillWaves wSpectrum_BandPass_BandPass

	// undo the lengthening to make it even
	if (wasOdd)
		redimension /N=(numpnts(waveOut)-1) waveOut
	endif

	// undo the-time scale changes
	if (wasRedimensioned)
		SetScale/P x leftx(waveOut)*1000, deltax(waveOut)*1000, "ms", waveOut
	endif
	SetScale/P x originalLeftx, deltax(waveOut), WaveUnits(waveOut, 0), waveOut
	
	// undo trend removal if there is no low cut
	if (loCutInHz==0)
		waveOut[] += p * trendAmplitudePerPoint
	endif
	
	//	after the IFFT, the note is lost, so let's add it back
	Note /K waveOut note($waveNameIn)
end