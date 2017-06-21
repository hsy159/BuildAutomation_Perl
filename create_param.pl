use strict;
use warnings;
use ElectricCommander; 
use encoding 'utf8';


my $ec = new ElectricCommander();  
my $myProjectName = "$[/myProject/projectName]";
my $myProcedureName = "$[/myProcedure/procedureName]"; 



sub create_0_2_Vehicle {
	my $paramName= shift;
	my $projectName = shift;
	my $procedureName = shift;
	my $vehicle_NO = shift;
	$ec->createFormalParameter($projectName, $procedureName, $paramName, { type => "entry", required => 0, defaultValue => "$vehicle_NO" });

	$ec->setProperty("ec_customEditorData/parameters/$paramName/formType" , "standard", {projectName=>$projectName, procedureName=>$procedureName} ); 	
}
 sub create_git_path {
	my $paramName= shift;
	my $projectName = shift;
	my $procedureName = shift;
	$ec->createFormalParameter($projectName, $procedureName, $paramName, {
							  type => "entry",
							  required => 1,
							  defaultValue => "ssh://gerrit.daudio/Mobis/device/mobis/daudio2",
							  description => "git clone ssh://gerrit.daudio/Mobis/device/mobis/daudio2"
							  });	
		
	$ec->setProperty("ec_customEditorData/parameters/$paramName/formType" , "standard", {projectName=>$projectName, procedureName=>$procedureName} ); 	
}

sub create_Comparison_with_doc {
	my $paramName= shift;
	my $projectName = shift;
	my $procedureName = shift;
	$ec->createFormalParameter($projectName, $procedureName, $paramName, {
							  type => "checkbox",
							  required => 0,
							  description =>"빌드하고자 하는 차종의 Makefile 과 옵션문서를 통해 생성된 Makefile 간 비교 검사 수행"
							 });	
		
	$ec->setProperty("ec_customEditorData/parameters/$paramName/initiallyChecked" , "0", {projectName=>$projectName, procedureName=>$procedureName} );
	$ec->setProperty("ec_customEditorData/parameters/$paramName/checkedValue" , "true" , {projectName=>$projectName, procedureName=>$procedureName});
	$ec->setProperty("ec_customEditorData/parameters/$paramName/uncheckedValue" , "false" , {projectName=>$projectName, procedureName=>$procedureName});	
}

sub create_Option_Doc_Tagging {
	my $paramName= shift;
	my $projectName = shift;
	my $procedureName = shift;
	$ec->createFormalParameter($projectName, $procedureName, $paramName, {
							  type => "select",
							  required => 1,
							  description => "비교 검사하고자 하는 옵션 문서의 Tag를 지정"
							 });	
		
	$ec->setProperty("/projects/$projectName/procedures/$procedureName/ec_customEditorData/parameters/System_OS_7_Makefile_Option_Doc_Tagging/formType", "standard");
	$ec->setProperty("/projects/$projectName/procedures/$procedureName/ec_customEditorData/parameters/System_OS_7_Makefile_Option_Doc_Tagging/options/optionCount", "3");
	$ec->setProperty("/projects/$projectName/procedures/$procedureName/ec_customEditorData/parameters/System_OS_7_Makefile_Option_Doc_Tagging/options/type", "list");
	$ec->setProperty("/projects/$projectName/procedures/$procedureName/ec_customEditorData/parameters/System_OS_7_Makefile_Option_Doc_Tagging/options/option1/text", "Head - The lastest version of the master branch");
	$ec->setProperty("/projects/$projectName/procedures/$procedureName/ec_customEditorData/parameters/System_OS_7_Makefile_Option_Doc_Tagging/options/option1/value", "1");
	$ec->setProperty("/projects/$projectName/procedures/$procedureName/ec_customEditorData/parameters/System_OS_7_Makefile_Option_Doc_Tagging/options/option2/text", "Same - The same tag as the source code's tag which is specified at [System_OS_4_Build_Version]");
	$ec->setProperty("/projects/$projectName/procedures/$procedureName/ec_customEditorData/parameters/System_OS_7_Makefile_Option_Doc_Tagging/options/option2/value", "2");
	$ec->setProperty("/projects/$projectName/procedures/$procedureName/ec_customEditorData/parameters/System_OS_7_Makefile_Option_Doc_Tagging/options/option3/text", "Specific tag - It is nessasary to input the tag name at [System_OS_8_Makefile_Option_Doc_Version]");
	$ec->setProperty("/projects/$projectName/procedures/$procedureName/ec_customEditorData/parameters/System_OS_7_Makefile_Option_Doc_Tagging/options/option3/value", "3");	
}

sub create_Option_Doc_Version {
	my $paramName= shift;
	my $projectName = shift;
	my $procedureName = shift;
	$ec->createFormalParameter($projectName, $procedureName, $paramName, {
							  type => "entry",
							  required => 0,
							  defaultValue => "",
							  description => "[System_OS_7_Makefile_Option_Doc_Tagging] 에 'Specific tag' 를 지정한 경우, Makefile 옵션 문서의 Tag 명을 입력"
							 });	
		
	$ec->setProperty("ec_customEditorData/parameters/$paramName/formType" , "standard", {projectName=>$projectName, procedureName=>$procedureName} ); 	
}



create_0_2_Vehicle("0_2_Vehicle",$myProjectName,$myProcedureName,$vehicle_NO);
create_git_path("git_path",$myProjectName,$myProcedureName);
create_Comparison_with_doc("System_OS_7_Makefile_Comparison_with_Document",$myProjectName,$myProcedureName);
create_Option_Doc_Tagging("System_OS_7_Makefile_Option_Doc_Tagging",$myProjectName,$myProcedureName);
create_Option_Doc_Version("Input_System_OS_8_Makefile_Option_Doc_Version",$myProjectName,$myProcedureName);
