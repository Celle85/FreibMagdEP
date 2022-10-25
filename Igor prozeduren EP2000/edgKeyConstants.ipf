#pragma rtGlobals=1		// Use modern global access method.

	StrConstant kCopyright = "©2002-2013 Prof. M. Bach"

	// keywords for the wave note, as used in saved measurements
	StrConstant kKeyVersion = "vs"					// Version of data acquisition program
	StrConstant kKeyEPNumber = "epNum"			// EP number
	StrConstant kKeyBlockNumber = "blockNum"		// block number (0=A, 1=B, É)
	StrConstant kKeyStimNumber = "stimNum"		// stimulus number
	StrConstant kKeyChannel = "channel"			// channel numbers start with 0 internally and with 1 in the user interface
	StrConstant kKeyDateRecording = "date"			// examination date
	StrConstant kKeyTimeRecording = "time"			// examination time
	StrConstant kKeySubjectName = "subjectName"	// standard sequence: surname, given name
	StrConstant kKeyDateBorn = "dateBorn"			// birthdate
	StrConstant kKeyAcuityOD = "acuityOD"			// acuity right eye
	StrConstant kKeyAcuityOS = "acuityOS"			// acuity left eye
	StrConstant kKeyAcuityCurrent = "acuityCurrent"			// acuity of the current channel / block
	StrConstant kKeyDoctor = "physician"			// referring doctor
	StrConstant kkeyPIZ = "subjectPIZ"
	StrConstant kkeyPIZ2 = "gSubjectPIZ"			// this is an unfortunate accident (added 2010-03-19)
	StrConstant kKeyDiagnosis = "diagnosis"			// clinical question in brief, per session
	StrConstant kKeyRemark = "remark"				// comment, per record
	StrConstant kKeyEyeKey = "eyeKey"				// eye recorded
	StrConstant kKeyEPKey = "epKey"				// type of EP: (P)ERG / VEP / Oz, O1, É
	StrConstant kKeySweeps = "nSweeps"			// number of sweeps averaged
	StrConstant kKeyArtefs = "nArtefs"				// number of artifacts rejected
	StrConstant kKeySeqName = "seqName"			// "name" of the stimulus sequence 
	StrConstant kKeyStimName = "stimName"		// "name" of the stimulus 
	StrConstant kKeyStimSymmetry = "symmetry"	// Reversal: true, most others: false
	StrConstant kKeyStimLuminance = "luminance"	// in cd/sqm
	StrConstant kKeyStimContrast = "contrast"		// in %
	StrConstant kKeyStimFrequency = "frequency"	// for reversals: half the reversal reate
	StrConstant kKeyStimOnTime1 = "onTime1"		// time [ms] when the stimulus is "on", e.g. moving
	StrConstant kKeyStimElementSize = "elemSize"	// size of an element in ¡, e.g. one check
	StrConstant kKeyStimSpeed = "motionSpeed"	// speed in ¡/s
	StrConstant kKeyOffTime = "OffTime1"

// ERG
	StrConstant kKeyStimIntensity = "stimIntensity"
	StrConstant kKeyFlashStrength = "flashStrength"
	StrConstant kKeyBackgroundLuminance = "backgroundLuminance"	// in cd/sqm new version starting 2009
