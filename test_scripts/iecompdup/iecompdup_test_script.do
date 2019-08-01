
*Test for user specified variable names in Excel report
********************************************************

	clear all
	
	global GitHub "C:\Users\wb501238\Documents\GitHub\iefieldkit\src\ado_files"
	
	do "${GitHub}/iecompdup.ado"
	
/*******************************************************************************
	Prepare data
*******************************************************************************/
	
	sysuse auto, clear
	
	encode make, gen(uuid)

	* Two duplicates
	replace uuid = 1 if (uuid <= 2)
	
	* Three duplicates 
	replace uuid = 2 if (uuid > 1 & uuid <= 5)
	
	* Four duplicates 
	replace uuid = 3 if (uuid > 2 & uuid <= 9)
	
	gen    	key 		= _n
	gen		wrong_key 	= key
	replace wrong_key 	= 2 if uuid == 2
	gen 	oi 	 		= "oi"
	
	* String ID
	tostring uuid, gen(str_id)
	gen str_id_space = str_id + " space"
	
	tempfile  testdata
	save	 `testdata'

	
/*******************************************************************************
	Should return no error
*******************************************************************************/

*-------------------------------------------------------------------------------
* 	String IDs
*-------------------------------------------------------------------------------
	
	iecompdup str_id, id("1")
	iecompdup str_id = 1
	
	iecompdup str_id_space, id("1 space")
	iecompdup str_id_space = 1 space
	
*-------------------------------------------------------------------------------
* 	Two duplicates
*------------------------------------------------------------------------------- 

	iecompdup uuid, id(1)
	iecompdup uuid = 1
	
	iecompdup uuid, 	didiff id(1)
	iecompdup uuid = 1, didiff
	
	iecompdup uuid, 	didiff keepdiff id(1)
	iecompdup uuid = 1, didiff keepdiff
	
	use `testdata', clear
	iecompdup uuid, 	keepdiff keepother(oi) id(1)
	iecompdup uuid = 1, keepdiff keepother(oi)
	
*-------------------------------------------------------------------------------
* 	More than two duplicates
*------------------------------------------------------------------------------- 
	
	* With string key
	use `testdata',		clear
	iecompdup uuid 		if inlist(make, "Audi 5000", "Audi Fox"), id(2) 
	
	use `testdata', 	clear
	iecompdup uuid = 2 	if inlist(make, "Audi 5000", "Audi Fox")
	
	use `testdata', 	clear
	iecompdup uuid 		if inlist(make, "Audi 5000", "Audi Fox"), didiff keepdiff id(2)
	
	use `testdata', 	clear
	iecompdup uuid = 2 	if inlist(make, "Audi 5000", "Audi Fox"), didiff keepdiff
		
	* With numeric key
	use `testdata', 	clear
	iecompdup uuid 		if inlist(key, 53, 54 ), id(2)
	
	use `testdata', 	clear
	iecompdup uuid = 2	if inlist(key, 53, 54 )
	
	use `testdata', 	clear
	iecompdup uuid 		if inlist(key, 53, 54 ), didiff keepdiff id(2) 
	
	use `testdata', 	clear
	iecompdup uuid = 2	if inlist(key, 53, 54 ), didiff keepdiff
	
	* With more2ok
	use `testdata', 	clear
	iecompdup uuid, 	more2ok id(2)
	
	use `testdata', 	clear
	iecompdup uuid = 2, more2ok
	
	use `testdata', 	clear
	iecompdup uuid, 	more2ok didiff keepdiff id(2) 
	
	use `testdata', 	clear
	iecompdup uuid = 2, more2ok didiff keepdiff
		
	
/*******************************************************************************
	Should return error
*******************************************************************************/

	use `testdata', clear
	
*-------------------------------------------------------------------------------
* 	No duplicates
*------------------------------------------------------------------------------- 
	
	*iecompdup uuid, id(15)
	*iecompdup uuid = 15
	
	*iecompdup uuid if key == 210938, id(0)
	*iecompdup uuid = 0 if key == 210938
	
*-------------------------------------------------------------------------------
* 	Two duplicates
*------------------------------------------------------------------------------- 

	*iecompdup uuid, id(1) keepother(oi)
	*iecompdup uuid = 1, keepother(oi)

*-------------------------------------------------------------------------------
* 	More than two duplicates
*------------------------------------------------------------------------------- 

	*iecompdup uuid, id(2)
	*iecompdup uuid = 2
	
	*iecompdup uuid if inlist(key, 53, 54, 3), id(2)
	*iecompdup uuid = 2 if inlist(key, 53, 54, 3)
