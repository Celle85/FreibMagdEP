#pragma rtGlobals=1		// Use modern global access method.


//	2010-03-11		ausgelagert. mb

 

Function IgorBeforeQuitHook(unsavedExp, unsavedNotebooks, unsavedProcedures)
	Variable unsavedExp, unsavedNotebooks, unsavedProcedures
	ExperimentModified 0
	Execute/Q/P "ExperimentModified 0"	// to get rid of the saving question, return value is ignored
	return 1	// to get rid of the saving question
end


Function IgorBeforeNewHook(igorApplicationNameStr)
	String igorApplicationNameStr
#if Exists("DoBeforeCloseHook")
	DoBeforeCloseHook(0)
#endif
	ExperimentModified 0
	Execute/Q/P "ExperimentModified 0"	// to get rid of the saving question, return value is ignored
end


Function IgorStartOrNewHook(igorApplicationNameStr)
	String igorApplicationNameStr
	ExperimentModified 0
	Execute/Q/P "ExperimentModified 0"	// to get rid of the saving question, return value is ignored
end


Function IgorMenuHook(isSelection, menuStr, itemStr, itemNo, topWindowNameStr, wType)
	Variable isSelection;  String menuStr, itemStr;  Variable itemNo;  String topWindowNameStr;  Variable wType
	ExperimentModified 0
	Execute/Q/P "ExperimentModified 0"	// to get rid of the saving question
	return 0	// we have not handled the menu
end


Function edgForceNoSave_BackgroundTask()
	ExperimentModified 0	// to get rid of the saving question
	return 0	// Tell Igor to continue calling background task
end

