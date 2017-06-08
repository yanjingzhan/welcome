local sz = require("sz")
local http = require("szocket.http")
local res, code = http.request("http://ios.pettostudio.net/AccountInfo.aspx?action=GetASOTaskForPhone&state=die&phonegroup=1");

if code == 200 then
	toast(res);
	local ts = require("ts");
	local json = ts.json;

	local index = string.find(res,"Account");
	
	dialog(tostring(index), 6);
	
	local tmp = json.decode(res);

	dialog(tmp.Account, 5);
end