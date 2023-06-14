axlCmdRegister("add_layer" `add_layer)
(defun add_layer ()
input_layer = axlEnterString(
            ?prompts list("Please enter your name:"))			
tach_so=parseString(input_layer)
star=car(tach_so)
star_so=atoi(star)
end=cadr(tach_so)
end_so=atoi(end)+1

	axlLayerCreateCrossSection("BOTTOM" "DIELECTRIC" "FR-4" get_pname(concat("VP" (end_so-1))) "Positive")	
	x=get_pname(concat("VP" (end_so-1)))
		for(i star_so end_so	
				ii=(end_so-(i-star_so))
					if(ii > star_so then
						
							axlLayerCreateCrossSection(x "DIELECTRIC" "FR-4" y=get_pname(concat("VP" (ii-1))) "Positive")
							axlLayerCreateCrossSection(y "Conductor" "TUNGSTEN" x=get_pname(concat("MP" (ii-1))) "Positive")
					)
			)

	)
;#####################
axlCmdRegister("crea_sym" `crea_sym)
(defun crea_sym ()
	input_file = axlDMFileBrowse(nil nil ?title "Please choose file create Pins ..." ?optFilters "All text files|*.txt|")
	dem=0
	if(input_file != nil then
		inPort = infile(input_file)
		when(inPort
			while(gets(nextline inPort)
			
				if(length(parseString(nextline)) == 4 then
					nextline1 = car(parseString(nextline, "\n"))
					nextline1 = parseString(nextline1)
					colum1=car(nextline1)
					colum2=cadr(nextline1)
					colum3=atof(car(cdr(cdr(nextline1))))
					colum4=atof(car(cdr(cdr(cdr(nextline1)))))
					
					mytext = make_axlTextOrientation(?textBlock 1, ?rotation 0.0 ?mirrored nil ?justify "left")
					mypin = make_axlPinText(?number colum2,?offset 0:0, ?text mytext)
					axlDBCreatePin( colum1 xy mypin 0.0)
						dem=dem +1
				else
					printf("Stoped! Invalid database.\n")
				);end if 
				
			);end while
		);end when
		printf("Finish ! Creation's %n Pins\n", dem )
		close(inPort)

	);end if
)
;###########################
axlCmdRegister("sort_text" `sort_text)
(defun sort_text ()
	axlSetFindFilter(?enabled '(noall SYMBOLS PINS VIAS NETS CLINES TEXT NAMEFORM) ?onButtons '(noall TEXT))
	mypopup = axlUIPopupDefine(nil (list (list "Done" 'axlFinishEnterFun) (list "Cancel" 'axlCancelEnterFun)))
	axlUIPopupSet( mypopup)
	dem=0
	Input_List =nil
	while(axlSelect(?prompt "Please select an element...")
	if( Input_List != nil then
	axlUIWClose(view))
	Input_List = axlGetSelSet()
	axlClearSelSet()
	

			if(length(Input_List) != 0 then
				Out_File = outfile("./sort_text.log" "w")
				
				foreach(item Input_List
					Item_Obj = item->objType
					if((Item_Obj == "text") then
							sub_c=item->layer
							printf("%n\n" strlen(sub_c))
								fprintf(Out_File, "%s %L %L %s\n", item->text, xCoord(item->xy) yCoord(item->xy), substring(sub_c  16 strlen(sub_c)-16))
								dem=dem+1			
						)
						)
						printf("%s\n", "-------------------------------------------------")
						printf("Issues exists in your design : %n TEXT\n", dem)
						printf("%s\n", "-------------------------------------------------")
							
				close(Out_File)
			
				printf("Total: %n TEXTS in your design \n" dem)
				dem=0

				view = axlUIViewFileCreate("sort_text.log", "Show Element TEXT" nil)
				
				
				
				
			else
				printf("No Element found!\n")
				
				
			)
			
	)	
)
;###########################create_symbol######################
axlCmdRegister("Cre_sym" `Cre_sym)
(defun Cre_sym ()
	axlSetFindFilter(?enabled '(noall SYMBOLS PINS VIAS NETS CLINES TEXT NAMEFORM) ?onButtons '(noall TEXT))
	mypopup = axlUIPopupDefine(nil (list (list "Done" 'axlFinishEnterFun) (list "Cancel" 'axlCancelEnterFun)))
	axlUIPopupSet( mypopup)
	dem=0
	Input_List=nil
	while(axlSelect(?prompt "Please select an element...")
	Input_List = axlGetSelSet()
	axlClearSelSet()
	
	colum1_1_1 = axlEnterString( ?prompts list("Please enter your name:"))
						colum1_1=parseString(colum1_1_1)
						colum1=car(colum1_1)
						printf("%L\n" colum1)
						num_str=atoi(cadr(colum1_1))
						printf("%L\n" num_str)

			if(length(Input_List) != 0 then
				Out_File = outfile("./get_text.log" "w")
				
				foreach(item Input_List
					Item_Obj = item->objType
					if((Item_Obj == "text") then
							get_text=item->text
							colum2=substring(get_text (num_str+1) (strlen(get_text)-num_str))
								
								fprintf(Out_File, "%s %L %L\n",colum2 , xCoord(item->xy) yCoord(item->xy))
											
						)
						)
						close(Out_File)
						view=axlUIViewFileCreate("get_text.log", "Show Element TEXT" nil)
						inPort = infile("get_text.log")
						if( Input_List != nil then
							axlUIWClose(view))
						
								
						
		when(inPort
			while(gets(nextline inPort)
			
				if(length(parseString(nextline)) == 3 then
					nextline1 = car(parseString(nextline, "\n"))
					nextline1 = parseString(nextline1)
					colum2=car(nextline1)
					
					;printf("%s\n" colum2)
					colum3=atof(cadr(nextline1))
					;printf("%n\n" colum3)
					colum4=atof(car(cdr(cdr(nextline1))))
					;printf("%n\n" colum4)
					mytext = make_axlTextOrientation(?textBlock 1, ?rotation 0.0 ?mirrored nil ?justify "left")
					mypin = make_axlPinText(?number colum2,?offset 0:0, ?text mytext)
					axlDBCreatePin( colum1 colum3:colum4 mypin 0.0)
						dem=dem +1
				else
					printf("Stoped! Invalid database.\n")
				);end if 
				
			);end while
		);end when
		printf("Finish ! Creation's %n Pins\n", dem )
		close(inPort)		
						printf("%s\n", "-------------------------------------------------")
						printf("Issues exists in your design : %n TEXT\n", dem)
						printf("%s\n", "-------------------------------------------------")
	
			else
				printf("No Element found!\n")
				
			)
	)	
)