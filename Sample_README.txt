1. In the build action of your application scheme, build the UnitTestRunner target of the UnitTestRunner project.  This target will build both the resource bundle and the static library.

2. Drag the Unit Test Runner library from the Products group of the UnitTestRunner project to the "Link Binary With Libraries" build phase of the application.

3. Drag the UnitTestRunnerResources.bundle bundle from the build products directory of the workspace into the sample app.  In the "identity and type" utility view, mark the bundle file as being located "relative to build products".  This will allow the resource bundle to be copied into the application's resources. (ensure the bundle is in the "Copy Bundle Resources" build phase of the application).

4. Edit the "Framework Search Paths" of your application target to include "/Developer/Library/Frameworks"

5. Edit the header search paths of your application target to include /usr/include/libxml2.  Add the libxml2.dylib dynamic library to your application project.

4. Include the <UnitTestRunner/UnitTestRunner.h> to get at the test runner headers. Add the SenTestingKit from your SDK's /Developer/Library/Frameworks folder to the project.

6. Implement a run results delegate, TestRunResultsDialogDelegate. 

7. Create a run results dialog pointed at the delegate and put it on screen using presentModalViewController (or related), tell it to run the tests:

    TestRunResultsDialog *runResultsDialog = [TestRunResultsDialog createRunResultsDialogWithDelegate: self];
    [self.viewController presentModalViewController: runResultsDialog animated: YES];    
	[runResultsDialog runAllUnitTests: self];

