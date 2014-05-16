Instructions for download and install P5.3 watershed model

1. Download P5.3 model files
	a) Files are located in compressed tar format at ftp.chesapeakebay.net/Modeling/phase5/community/P53 in subfolders
	b) Download each tar file to a common directory for the Phase 5.3 Model (e.g. myP53 etc.)

2. Unzip the files
	a) Use the command "tar -xjvf" to decompress and unzip the code, config, run and document model files.
            	-code.tar, config.tar, run.tar, and document.tar will produce directory structures with similar names
		-Due to its size, the input directory has been further subdivided.  To set up the directory structure,
			-In model directory (e.g. myP53 etc.), use the command "mkdir input" to make an "input" directory.
			-Move the scenario_climate/land/river.tar, calib.tar and param.tar files into that input directory.
			-Untar those files in the "input" folder.

	b) The resulting directory structure should contain
		-code
		-config
		-run
		-documentation
		-input
			-scenario
				-climate
				-land
				-river
			-calib
			-param

3. Compile the model codes
       a)  compile HSPF codes
		*in the ./code/src/hspf/lib3.2/src/ directory, run make.
		*in the ./code/src/hspf/lib3.2/src/adwdm, 
			copy the "makefile" to a new name(e.g. cp makefile regmakefile), copy quietmake to makefile, run make, copy the regmakefile back to makefile, and remove regmakefile.
		*in the ./code/src/hspf/lib3.2/src/phspf
			run make
		*in the ./code/src/hspf/lib3.2/src/ghspf
			run make

           
		* in the ./code/src/hspf/hspf11.1/src directory:  
                     	copy quietmake to makefile, run make 
                     	copy gmakefile to makefile,  run make
        

	b) compile P5.3 model codes
            Run compile_all.csh in the ./code/src/ directory to generate all executable files
  
4. Check your model installation
   A test case is created to help confirm the model files are properly installed.  The scenario for the test case is "p53cal", and the basin is "pax". To start the test, here are the steps you need to follow:   

	a) In ./run/standard/ directory, run below two scripts to make land and river directories:
                  make_land_directory.csh  $scenario 
                  make_river_directory.csh  $scenario

	b) still in ./run/standard/ directory, test the model runs in one of two ways: 

           - run the model step by step (recommended). This way, if you run into problems, it will be easier to identify the source of the issue.

                  run_lug.csh     $scenario   $basin 
                  run_land.csh   $scenario  $basin
                  run_etm.csh    $scenario   $basin
                  run_rug.csh     $scenario   $basin
                  run_river.csh   $scenario   $basin
                  run_postproc.csh  $scenario   $basin

           - or run the whole model process in one single script:
                  run_all.csh    $scenario   $basin
         
       c)  In the run/standard directory, run below script to summarize average annual result by land use, basin or state.  This is useful to look at summary results.
                  summarize_output_aveann.csh $scenario $basin $year1 $year2

5. Start to learn how to use the model 
   Once you finish the test run without any problems, congratulations, you've successfully installed and run P5.3 model on your computer.   At this point, you will need to read Model_Operation_Manual.doc in the documentation directory to learn how to use the model for your own purpose.

