component {

function Read(arg) {
	if (IsSimpleValue(arg)) {
		local.PrimaryKey = arg; // They passed in an id
	} else {
		local.PrimaryKey = arg["#Variables.fw.TableName#ID"]; // They passed in arg.id
	}
	include '/Inc/newQuery.cfm';
	local.sql = "SELECT * FROM " 
		& Variables.fw.TableName
		& "View WHERE " 
		& Variables.fw.TableName 
		& "ID=" 
		& Val(local.PrimaryKey);
	include '/Inc/execute.cfm';
	return local.result;
}

function Where(arg,FieldValue,OrderBy) {
	//    Usage: 
	// a. obj = new com.Usr().Where("Something",1,"UsrSort DESC");
	//    or
	// b. arg.FieldName = "Something";
	//    arg.FieldValue = 1;
	//    arg.OrderBy = "UsrSort DESC";
	//    obj = new com.Usr().Where(arg);
	
	include '/Inc/newQuery.cfm';
	if (StructKeyExists(arguments,"arg")) {
		if (IsSimpleValue(arg)) { // Example a
			local.sql = 'SELECT * FROM ' & Variables.fw.TableName & 'View WHERE ' & arguments.arg & ' = ' & Val(arguments.FieldValue);
		} else { // 1 parameter: arg.FieldName, arg.FieldValue and arg.OrderBy (Example b)
			local.sql = 'SELECT * FROM ' & Variables.fw.TableName & 'View WHERE ' & arg.FieldName & ' = ' & Val(arg.FieldValue);
		}
	} else { // 0 parameters
		local.sql = 'SELECT * FROM ' & Variables.fw.TableName & 'View';
	}
	if (StructKeyExists(arguments,'OrderBy')) { // 3 parameters (Example a)
		local.sql &= ' ORDER BY ' & arguments.OrderBy;
	} else if (IsDefined("arguments.arg.OrderBy")) { // 1 parameter: arg.FieldName, arg.FieldValue and arg.OrderBy (Example b)
		local.sql &= ' ORDER BY ' & arguments.arg.OrderBy;
	} else { // 0 parameters or 2 parameters (Example a)
		local.sql &= ' ORDER BY ' & Variables.fw.TableSort;
	}
	include '/Inc/execute.cfm';
	return local.result;
}

function Delete(arg) {
	include '/Inc/newQuery.cfm';
	local.PrimaryKey = arg["#Variables.fw.TableName#ID"];
	local.sql = "DELETE FROM "
		& Variables.fw.TableName
		& " WHERE "
		& Variables.fw.TableName
		& "ID="
		& Val(local.PrimaryKey);	
	include '/Inc/execute.cfm';
	return local.result;
}
}