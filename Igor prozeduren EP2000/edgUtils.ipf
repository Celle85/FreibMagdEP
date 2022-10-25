#pragma rtGlobals=1		// Use modern global access method.

//	Änderungsprotokoll
//	==============
//
//	2010-03-31		StringWordWrap: improved algorithm to deal with longer strings (mb)
//	2010-03-04		StringTrim & StringTrim4Numbers getrennt (mb)
//	2009-08-05		als "Utils" ausgelagert (mb)
//	13.07.2000	Im “BandpassFilter” Trend berücksichtigt mb
//					KillAll* dazu


constant true = 1, false = 0


function IsOdd(theNumber)
	variable theNumber
	return ((trunc(theNumber)) & 1)
end	


// if "condition2exit" is true, then "theMessage" is displayed in a dialog, then the program aborts
function ErrorExitCheck(condition2exit, theMessage)	
	variable condition2exit;  string theMessage
	if (condition2exit)
		Abort theMessage
	endif
end



/////////////////////////////////////////////////////////////////////////////////
function o____STRING_FUNCTIONS____()
	return 0
end
/////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////
// are 2 strings equal?  [easier than cmpstr]
//////////////////////////////////
function StringEqual(str1, str2)
	string str1, str2
	return (0 == cmpstr(str1, str2 ))
end


//////////////////////////////////
// remove leading blanks & trailing zeros
//////////////////////////////////
function /s StringTrim(s)	
	string s
	variable c
	do	// remove leading blanks 
		c = cmpstr(s[0], " ")
		if (c==0)
			s = s[1, strlen(s)-1]
		endif
	while (c==0)
	if (strsearch(s, ".", 0 ) != -1)
		do	// remove trailing zeros
			c =  cmpstr(s[strlen(s)-1], "0")
			if (c==0)
				s = s[0, strlen(s)-2]
			endif
		while (c==0)
	endif
	return s
end


//////////////////////////////////
// remove leading blanks & trailing zeros
//////////////////////////////////
function /s StringTrim4Numbers(s)	
	string s
	s = StringTrim(s)
	if (cmpstr(s[strlen(s)-1], ".")==0)	// jetzt ggf. wieder ne 0 dran
		s = s+"0"
	endif
	return s
end


//////////////////////////////////
// Paragraph Wrapping
//////////////////////////////////
function /S StringWordWrap(theString, maxLineLengthInPixels, [fontNameStr, fontSize, fontstyle, maxClauses])
	string theString, fontNameStr
	variable maxLineLengthInPixels, fontSize, fontStyle, maxClauses
	if (paramisdefault(fontNameStr))
		fontNameStr="Helvetica"
	endif
	fontsize = ParamIsDefault(fontsize) ? 10 : fontsize
	fontStyle = ParamIsDefault(fontsize) ? 1 : fontStyle
	maxClauses = ParamIsDefault(maxClauses) ? 4 : maxClauses
	string paragraphSeparator = "\r", wordSeparator = " ", oneWordParsedString, returnVal=""
	variable i, k, nWords, oneWordPixelValue, currentPixelValue
	for(k=0; k<maxClauses; k +=1)
		string  currentParsedString="", stringClause = StringFromList(k, theString, paragraphSeparator)
		nWords=ItemsInList(StringClause, wordSeparator);  currentPixelValue = 0
		for (i=0; i<nWords; i+=1)
			oneWordParsedString = StringFromList(i, stringClause, wordSeparator)
			oneWordPixelValue = FontSizeStringWidth(fontNameStr, fontSize, fontstyle, oneWordParsedString)
			if (currentPixelValue >= maxLineLengthInPixels)
				currentParsedString = currentParsedString + paragraphSeparator + oneWordParsedString + wordSeparator
				currentPixelValue = 0
			else
				currentParsedString = currentParsedString+oneWordParsedString + wordSeparator
				currentPixelValue = currentPixelValue+oneWordPixelValue
			endif
		endfor	
	 	returnVal += currentParsedString + paragraphSeparator
	endfor
	return returnVal
end


//////////////////////////////////
// Wandlung einer Gleitkommazahl in einen String. i: Zahl der Nachkommastellen
//////////////////////////////////
Function /S rStr(r, i)
	Variable	r, i
	if (r==0.0)
		return "0"
	endif
	if (numtype(r) != 0)
		return "NaN"	
	endif
	String	theResult
	sprintf theResult, "%*.*f", 20, i, r;  return StringTrim(theResult)
end


//////////////////////////////////
// Wandlung einer Gleitkommazahl in einen String. Automatisch "vernünftige Genauigkeit" von 0,1%-1%
//////////////////////////////////
Function /S rStrAuto(r)
	Variable	r
	Variable nDecimals = min(8, max(0, 2-floor(log(abs(r)))))
	return  rStr(r, nDecimals)
end


//////////////////////////////////
// Wandlung einer Gleitkommazahl in einen String, mit Dezimalkomma statt Punkt. i: Zahl der Nachkommastellen
//////////////////////////////////
Function /S rStrDE(r, i)
	Variable	r, i
	SVAR gDecimalPointSymbol
	String theResult = rStr(r, i)
	i = strsearch(theResult, ".", 0)
	if (i>0)
		theResult[i, i] = gDecimalPointSymbol
	endif
	return theResult
end


//////////////////////////////////
// Wandlung einer Gleitkommazahl in einen String, mit Dezimalkomma statt Punkt. Automatisch "vernünftige Genauigkeit" von 0,1%-1%
//////////////////////////////////
Function /S rStrAutoDE(r)
	Variable r
	Variable nDecimals = min(8, max(0, 1-floor(log(abs(r)))))
	return  rStrDE(r, nDecimals)
end

//////////////////////////////////
// Wandlung eines Datums d.m.yyyy in einen datetime-Wert (seconds since 1.1.1904)
//////////////////////////////////


Function Date_d_m_yyyy2date(s)
	String	s
	Variable day, month, year
	s=ReplaceString(".", s, " ")
	sscanf s, "%i %i %i", day, month, year
	return date2secs(year, month, day )
end


//////////////////////////////////
// Wandlung eines Datums YYYYMMDD in DDMMYYYY
//////////////////////////////////

		
Function/S Date_YYYYMMDD2DDMMYYYY(theDate)
	String theDate
	variable day, month, year, secsDate
	string theNewDate = theDate
	if(((cmpstr(theDate[4,4], "-"))&&(cmpstr(theDate[7,7], "-")))==0)		//wenn Datum YYYY-MM-DD
		string theYear = ParseFilePath(0, theDate, "-", 0, 0); string theMonth = ParseFilePath(0, theDate, "-", 0, 1); string theDay = ParseFilePath(0, theDate, "-", 0, 2)		
		theNewDate = theDay + "." + theMonth + "." + theYear
	endif
	return theNewDate	
end		
 
 
/////////////////////////////////////////////////////////////////////////////////
function o____SCREEN_INFO____()
	return 0
end
/////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////
// Bildschirmbreite in Pixeln von Bildschirm n (n=1, 2, )
//////////////////////////////////
function GetScreenWidthN(n)
	variable n
	string s = StringByKey(("SCREEN"+num2str(n)), IgorInfo(0))
	return str2num(StringFromList(3, s  ,","))
end


//////////////////////////////////
// Bildschirmhöhe in Pixeln von Bildschirm n (n=1, 2, )
//////////////////////////////////
function GetScreenHeightN(n)
	variable n
	string s = StringByKey(("SCREEN"+num2str(n)), IgorInfo(0))
	return str2num(StringFromList(4, s  ,","))
end


function ScreenSize()// geht noch nicht
	variable i, n = NumberByKey("NSCREENS", IgorInfo(0))
	print n
	for (i=1; i<n+2; i+=1)
		print i;  print GetScreenWidthN(i), GetScreenHeightN(i)
	endfor
end



//////////////////////////////////
// to easily get values from a wave when only the name is known
//////////////////////////////////
Function GetValueFromWave(theWaveName, theX)
	string theWaveName;  variable theX
	wave theWave = $theWaveName;  return theWave(theX)
end


Function GetValueFromWaveAtIndex(theWaveName, theIndex)
	string theWaveName;  variable theIndex
	wave theWave = $theWaveName;  return theWave[theIndex]
end



/////////////////////////////////////////////////////////////////////////////////
function o____KIllStuff____()
	return 0
end
/////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////
Function KillAllGraphs()
	string list=WinList("*", ";", "WIN:1");  variable i, n=ItemsInList(list)
	for(i=n; i>0; i-=1)
		DoWindow /K $StringFromList(i-1, list)
	endfor
end


//////////////////////////////////
function KillAllTables()
	string list=WinList("*", ";", "WIN:2");	  variable i, n=ItemsInList(list)
	for(i=n; i>0; i-=1)
		DoWindow /K $StringFromList(i-1, list)
	endfor
end


//////////////////////////////////
function KillAllLayouts()
	string list=WinList("*", ";", "WIN:4");	  variable i, n=ItemsInList(list)
	for(i=n; i>0; i-=1)
		DoWindow /K $StringFromList(i-1, list)
	endfor
end


//////////////////////////////////
function KillAllNotebooks()
	string list=WinList("*", ";", "WIN:16");	  variable i, n=ItemsInList(list)
	for(i=n; i>0; i-=1)
		DoWindow /K $StringFromList(i-1, list)
	endfor
end


Function KillAllObjectsButSsAndVs()
	KillAllLayouts();	KillAllGraphs();	KillAllTables();
	Close /A;	KillWaves /A/Z
end


//////////////////////////////////
Function KillAllObjects()
	KillAllLayouts();	KillAllGraphs();	KillAllTables();  KillAllNotebooks()
	Close /A;  KillWaves /A/Z;  KillStrings /A/Z;  KillVariables /A/Z
end