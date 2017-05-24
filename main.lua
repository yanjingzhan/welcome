--com.apple.Preferences
--com.apple.AppStore


globlaAccount = "breonalanhywxuer@hotmail.com";
globlaPassword = "UQpqLi22";
globlaGameAccount = 1;
globlaKeyWords = "";
globlaBunldeName="";
globlaAppID="";

globlaIsInDownloading = false;

globlaInstallX=0;
globlaInstallY=0;

globalAllIsDone = false;
--globlaAccount = "a8673601@icloud.com";
--globlaPassword = "Asd112211";

--字符串分割函数
--传入字符串和分隔符，返回分割后的table
function string.split(str, delimiter)
	if str==nil or str=='' or delimiter==nil then
		return nil
	end

	local result = {}
	for match in (str..delimiter):gmatch("(.-)"..delimiter) do
		table.insert(result, match)
	end
	return result
end

--返回 true/false 账号 密码 游戏个数 关键字 bunldeNames, appIDs
function getAccountInfo(url)

	local sz = require("sz")
	local http = require("szocket.http")
	local res, code = http.request(url);

	if code == 200 then
		local tableTemp = string.split(res,",");

		toast(res);
--		toast(tableTemp[13]);
		if #tableTemp > 12 then
			return true,tableTemp[1],tableTemp[2],tableTemp[3],tableTemp[12],tableTemp[22],tableTemp[23];
		else 
			return false;
		end
	else
		return false;
	end
end

function findAndClickImage(imageName,x1,y1,x2,y2)
--	toast('正在寻找...' .. imageName);        
--	x, y = findImageInRegionFuzzy(imageName,90, x1, y1, x2, y2,0);--在（0,0）到（120,480）寻找刚刚截图的图片

	x,y = findImage(imageName,x1, y1, x2, y2);
	if x ~= -1 and y ~= -1 then        --如果在指定区域找到某图片符合条件
		toast('findImage:找到' .. imageName .. x .. y);       
		touchDown(x,y);
		mSleep(30);
		touchUp(x,y);
		return true;
	else                               --如果找不到符合条件的图片
--		toast('没有找到' .. imageName);       
		return false;
	end
end

function findImageClickArea(imageName,x11,y11,x12,y12,x21,y21)
--	toast('正在寻找...' .. imageName);        
	x, y = findImage(imageName, x11, y11, x12, y12);--在（0,0）到（120,480）寻找刚刚截图的图片
	if x ~= -1 and y ~= -1 then        --如果在指定区域找到某图片符合条件
		toast('findImageClickArea:找到' .. imageName .. x .. y);  
		touchDown(x21,y21);
		mSleep(30);
		touchUp(x21,y21);
		return true;
	else    
--		toast('没有找到' .. imageName);       
		return false;
	end
end

function findImageClickAreaList(imageAndAreaList)
	local result =false;
	for i=1,#imageAndAreaList,1 do
		--dialog("图片个数" .. #imageAndAreaList .. ";图片名字：" .. imageAndAreaList[i].imageName);

		local t = findImageClickArea(imageAndAreaList[i].imageName,imageAndAreaList[i].x11,imageAndAreaList[i].y11,imageAndAreaList[i].x12,imageAndAreaList[i].y12,imageAndAreaList[i].x21,imageAndAreaList[i].y21);
		if t then
			result = t;
		end
	end
	return result;

end

function  killVPN()
	for i=0,10,1 do
		flag = getVPNStatus()
		if flag.active then
			setVPNEnable(false);
		else
			return true;
		end
		mSleep(1000);
	end
	return false;
end

function  connectVPN(retryCount)
	for i=0,retryCount,1 do
		setVPNEnable(true);
		mSleep(3000);

		flag = getVPNStatus()
		toast(flag.status,1)
		if  string.find(flag.status,"已连接") == 1 or string.find(flag.status,"Connected") == 1  then
			return true;
		end
	end
	setVPNEnable(false);
	return false;
end

function reLogin(account,password,retryCount)
	for i=0,retryCount,1 do
		x, y = findImage("登录 iTunes Store.png", 178, 187, 485, 269);--在（0,0）到（120,480）寻找刚刚截图的图片
		if x ~= -1 and y ~= -1 then        --如果在指定区域找到某图片符合条件
			inputText(password);
			inputText("\n");

			return;
		else                               --如果找不到符合条件的图片
			toast('没有找到' .. "登录 iTunes Store.png");       
		end	
	end

end

function loginOutAppStore()
	closeApp("com.apple.AppStore"); 
	mSleep(1000);
	r = runApp("com.apple.AppStore");
	if r == 0 then
		mSleep(1000);
		appstoreLogout();

		for i = 0,100,1 do
			local status = appstoreStatus();
			mSleep(1000);
			toast(tostring(status),1);
			if status == 0 then
				break;
			end
		end
	end
end

function loginAppStore(account,password,retryCount,checkCount)
	closeApp("com.apple.AppStore"); 
	mSleep(1000);
	r = runApp("com.apple.AppStore");
	if r == 0 then
		toast("启动 AppStore 成功",1);
		mSleep(2000);
		local hasLoginned = true;
		for j=0,retryCount,1 do			
			toast("第" .. j .. "次执行登陆",1);

			appstoreLogout();
			mSleep(3000);
			appstoreLogin(account,password);

			for i=0,checkCount,1 do
				mSleep(6000);

				local imageDataList = {};
				imageDataList[1] = {imageName = "未能登录.png",x11 = 200,y11 = 470,x12 = 410,y12 = 530,x21 = 289,y21 = 648};
				imageDataList[2] = {imageName = "无法连接到.png",x11 = 120,y11 = 490,x12 = 320,y12 = 550,x21 = 290,y21 = 625};
				--				local status = findImageClickArea("未能登录.png",200,470,410,530,289,648);

				local status = findImageClickAreaList(imageDataList);
				if status then 
					toast("未能登录",1);	
					hasLoginned = false;
					break
				else
					toast(i .. "次检查",1);					
				end

				--				local x, y = findImage("登录 iTunes Store.png", 178, 187, 485, 269);--在（0,0）到（120,480）寻找刚刚截图的图片
				--				if x ~= -1 and y ~= -1 then        
				--					inputText(password);
				--					inputText("\n");
				--				else                               
				----					toast('没有找到' .. "登录 iTunes Store.png");       
				--				end	

				if findAndClickImage("使用现有的appleid.png",150,510,500,570) then
					mSleep(5000);
				end

				local x, y = findImage("登录 iTunes Store.png", 178, 187, 485, 269);--在（0,0）到（120,480）寻找刚刚截图的图片
				if x ~= -1 and y ~= -1 then     
					local x2, y2 = findImage("xample.png", 85, 274, 380, 314);
					if x2 ~= -1 and y2 ~= -1 then        
						inputText(globlaAccount);
						inputText("\n");

						mSleep(300);

						inputText(globlaPassword);
						mSleep(300);
						inputText("\n");
					else
						inputText(globlaPassword);
						mSleep(300);
						inputText("\n");
					end
				else                               
					--			toast('没有找到' .. "登录 iTunes Store.png");       
				end	

				if findImageClickArea("此AppleID只能在.png",80,430,560,480,300,700) then
					hasLoginned = true;
					break;
				end;

				if findImageClickArea("thisappliidisonly.png",80,410,560,460,300,700) then
					hasLoginned = true;
					break;
				end;
			end

			if hasLoginned then
				break
			end
		end

		if not hasLoginned then
			toast('执行登陆失败！！！',10);
			return false;
		end

		return true;
	else
		toast("启动 AppStore 失败",1);
		return false;
	end
end

function SerachFuck(keyword,appid)
	if isFrontApp("com.apple.AppStore") ~= 1 then

		runApp("com.apple.AppStore"); 
		mSleep(1000);
	end

	hasClickedSearchPNG = false;
	hasClickedSearchtopPNG = false;

	for i = 0,200,1 do
		if isFrontApp("com.apple.AppStore") ~= 1 then

			runApp("com.apple.AppStore"); 
		end

		mSleep(2000);

--		if not hasClickedSearchPNG then
		local x, y = findImageInRegionFuzzy("search.png",90,400,1040,477,1120,0);
		if x ~= -1 and y ~= -1 then   
			touchDown(x ,y);
			mSleep(30);
			touchUp(x,y);

			hasClickedSearchPNG = true;

		end
--		end

		if not hasClickedSearchtopPNG then 
			local x, y = findImageInRegionFuzzy("searchtop.png",95,15,60,600,110,0);
			if x ~= -1 and y ~= -1 then   
				touchDown(x + 100,y);
				mSleep(30);
				touchUp(x + 100,y);

				mSleep(1000);             

				AppstoreTopApp(appid);
				inputText(keyword .. "\n"); 
				inputText("\n");

				hasClickedSearchtopPNG = true;
			end
		end


		local x, y = findImageInRegionFuzzy("searchtop.png",95,240,60,460,110,0);
		if x ~= -1 and y ~= -1 then   
			touchDown(x + 100,y);
			mSleep(30);
			touchUp(x + 100,y);

			mSleep(1000);             

			AppstoreTopApp(appid);
			inputText("\b\b\b\b\b\b\b\b\b\b" .. keyword .. "\n"); 
			inputText("\n");
		end

		local x, y = findImage("gamelogo1.png", 188, 173, 521, 295);
		if x ~= -1 and y ~= -1 then   
			toast("找到了" .. keyword,1)
			break;   
		end

		findAndClickImage("使用现有的appleid.png",150,510,500,570);
		findAndClickImage("左上角search.png",5,50,180,110);

		local x, y = findImage("登录 iTunes Store.png", 178, 187, 485, 269);--在（0,0）到（120,480）寻找刚刚截图的图片
		if x ~= -1 and y ~= -1 then     
			local x2, y2 = findImage("xample.png", 85, 274, 380, 314);
			if x2 ~= -1 and y2 ~= -1 then        
				inputText(globlaAccount);
				inputText("\n");

				mSleep(300);

				inputText(globlaPassword);
				mSleep(300);
				inputText("\n");
			else
				inputText(globlaPassword);
				mSleep(300);
				inputText("\n");
			end
		else                               
			--			toast('没有找到' .. "登录 iTunes Store.png");       
		end	


		local x, y = findImage("无法连接到AppStore.png", 90, 500, 550, 585);
		if x ~= -1 and y ~= -1 then        
			return false; 
		end	

		local imageDataList = {};
		imageDataList[1] = {imageName = "在此设备上的.png",x11 = 70,y11 = 430,x12 = 580,y12 = 490,x21 = 490,y21 = 690};
		imageDataList[2] = {imageName = "是否为免费项目.png",x11 = 80,y11 = 455,x12 = 565,y12 = 510,x21 = 200,y21 = 660};
		imageDataList[3] = {imageName = "trequirepasswordfor.png",x11 = 80,y11 = 370,x12 = 565,y12 = 420,x21 = 300,y21 = 750};
		imageDataList[4] = {imageName = "无法连接到.png",x11 = 120,y11 = 490,x12 = 320,y12 = 550,x21 = 290,y21 = 625};
		imageDataList[5] = {imageName = "您必须同时输入.png",x11 = 80,y11 = 470,x12 = 340,y12 = 520,x21 = 440,y21 = 660};
		imageDataList[6] = {imageName = "youalreadypurchased.png",x11 = 80,y11 = 460,x12 = 550,y12 = 505,x21 = 320,y21 = 670};

		findImageClickAreaList(imageDataList);
	end

	for i =0,2000,1 do
		if isFrontApp("com.apple.AppStore") ~= 1 then
			runApp("com.apple.AppStore"); 
		end

		mSleep(2000);


		local x, y = findImageInRegionFuzzy("加号.png",95, 504, 190, 620, 290,0);
		if x ~= -1 and y ~= -1 then   			

			touchDown(x,y);
			mSleep(30);
			touchUp(x,y);

			toast("点击啦加号" .. keyword,1);
			mSleep(1000);

			touchDown(x,y);
			mSleep(30);
			touchUp(x,y);

			globlaInstallX = x +60;
			globlaInstallY = y + 20;

		end	

		local x, y = findImageInRegionFuzzy("hasdownloaded.png",95,540, 190, 620, 340,0);
		if x ~= -1 and y ~= -1 then   
			toast("已经下载过了！！！" .. keyword.. x .. ":" ..y,1)

			mSleep(1500);

			touchDown(x,y);
			mSleep(30);
			touchUp(x,y);

			--			return false;
		end

		local x, y = findImageInRegionFuzzy("install.png",95,470, 190, 620, 340,0);
		if x ~= -1 and y ~= -1 then   
			toast("Install ！！！" .. keyword.. x .. ":" ..y,1)

			mSleep(1500);

			touchDown(x,y);
			mSleep(30);
			touchUp(x,y);

			--			return false;
		end

		findAndClickImage("左上角search.png",5,50,180,110);
		findAndClickImage("使用现有的appleid.png",150,510,500,570);


		local x, y = findImage("登录 iTunes Store.png", 178, 187, 485, 269);--在（0,0）到（120,480）寻找刚刚截图的图片
		if x ~= -1 and y ~= -1 then     
			local x2, y2 = findImage("xample.png", 85, 274, 380, 314);
			if x2 ~= -1 and y2 ~= -1 then        
				inputText(globlaAccount);
				inputText("\n");

				mSleep(300);

				inputText(globlaPassword);
				mSleep(300);
				inputText("\n");
			else
				inputText(globlaPassword);
				mSleep(300);
				inputText("\n");
			end
		else                               
			--			toast('没有找到' .. "登录 iTunes Store.png");       
		end	

		local x, y = findImage("无法连接到AppStore.png", 90, 500, 550, 585);
		if x ~= -1 and y ~= -1 then        
			return false; 
		end	

		local imageDataList = {};
		imageDataList[1] = {imageName = "在此设备上的.png",x11 = 70,y11 = 430,x12 = 580,y12 = 490,x21 = 490,y21 = 690};
		imageDataList[2] = {imageName = "是否为免费项目.png",x11 = 80,y11 = 455,x12 = 565,y12 = 510,x21 = 200,y21 = 660};
		imageDataList[3] = {imageName = "trequirepasswordfor.png",x11 = 80,y11 = 370,x12 = 565,y12 = 420,x21 = 300,y21 = 750};
		imageDataList[4] = {imageName = "无法连接到.png",x11 = 120,y11 = 490,x12 = 320,y12 = 550,x21 = 290,y21 = 625};
		imageDataList[5] = {imageName = "您必须同时输入.png",x11 = 80,y11 = 470,x12 = 340,y12 = 520,x21 = 440,y21 = 660};
		imageDataList[6] = {imageName = "youalreadypurchased.png",x11 = 80,y11 = 460,x12 = 550,y12 = 505,x21 = 320,y21 = 670};

		findImageClickAreaList(imageDataList);

		--		if findAndClickImage("蓝块.png",540,190,625,275) then
		--			toast("下载成功并点击取消！！！",5);
		--		end

		local x, y = findImageInRegionFuzzy("蓝块.png",100, 540,190,625,310,0);
		if x ~= -1 and y ~= -1 then   
			toast('找到' .. "蓝块.png");  
			globalAllIsDone = true;

			mSleep(10000);
			touchDown(x,y);
			mSleep(30);
			touchUp(x,y);

			return true;
			--			dialog('找到' .. "蓝块.png");       
		else                               
			--			toast('没有找到' .. "蓝块.png");       
		end	
	end

	return false;
end

function NewDevice()
	fakePerApp({"com.apple.Preferences","com.apple.AppStore"});
	return  appDel({},{CarrierType="3G"});
end

function SlimAppStore()
	local bool,err = appSlim({"com.apple.AppStore"})
	return bool;
end 

function logoutAppStoreOnUI(timeout)
	--	mSleep(2000);
	local time1 = os.time();

	while true do

		findAndClickImage("存储容量几乎已满.png",100,470,520,530,190,50);

		local x, y = findImageInRegionFuzzy("appleid登录用.png", 95,10, 205, 185, 280,0);
		if x ~= -1 and y ~= -1 then

			touchDown(280,245);
			mSleep(30);
			touchUp(280,245);

			mSleep(1000);
		end	

		local x, y = findImageInRegionFuzzy("注销登录用.png",95, 160, 570, 470, 660,0);
		if x ~= -1 and y ~= -1 then
			
			touchDown(310,600);
			mSleep(30);
			touchUp(310,600);

			mSleep(3000);
		end

		local x, y = findImageInRegionFuzzy("登录登录用.png",95,10, 205, 185, 280,0);
		if x ~= -1 and y ~= -1 then
			toast("找到登录登录用.png;" .. x .. ":" .. y,1);
			return true;
		end

		mSleep(1000);

		local time2 = os.time();

		if (time2 - time1) >= timeout then
			return false;
		end
	end
end 

function  loginAppStoreOnUI(timeout)
	local time1 = os.time();
	while true do
--		toast("loginAppStoreOnUI循环...",1);

		findAndClickImage("存储容量几乎已满.png",100,470,520,530,190,50);

		local x, y = findImageInRegionFuzzy("登录登录用.png",95,10, 205, 185, 280,0);
		if x ~= -1 and y ~= -1 then

			touchDown(280,245);
			mSleep(30);
			touchUp(280,245);

			mSleep(4000);
		end

		local x, y = findImageInRegionFuzzy("appleid登录界面的登录用.png",85,190, 220, 350, 270,0);
		--		local x,y = findImage("appleid登录界面的登录用.png",190, 220, 350, 270);

		if x ~= -1 and y ~= -1 then

			local x, y = findImageInRegionFuzzy("框内的appleid登陆用.png",90,87, 309, 210, 350,0);
			if x ~= -1 and y ~= -1 then

				mSleep(300);
				inputText(globlaAccount);
				mSleep(300);
				inputText("\n");

				mSleep(1000);
				inputText(globlaPassword);
				mSleep(300);
				inputText("\n");

			else
				keyDown("DeleteOrBackspace");
				mSleep(5000);
				keyUp("DeleteOrBackspace");

				inputText(globlaAccount);
				inputText("\n");

				mSleep(300);

				keyDown("DeleteOrBackspace");
				mSleep(5000);
				keyUp("DeleteOrBackspace");

				inputText(globlaPassword);
				mSleep(300);
				inputText("\n");
			end
			mSleep(4000);
		end

		local x, y = findImageInRegionFuzzy("appleid登录用.png", 95,10, 205, 185, 280,0);
		if x ~= -1 and y ~= -1 then

			return true;
		end	

		local x, y = findImageInRegionFuzzy("thisappleidisonly登录用.png", 95,70, 400, 420, 460,0);
		if x ~= -1 and y ~= -1 then

			touchDown(320,720);
			mSleep(30);
			touchUp(320,720);

			return true;
		end	

		mSleep(2000);

		local time2 = os.time();

		if (time2 - time1) >= timeout then
			return false;
		end
	end
end

function CleanAccounts()
	os.execute("cp -rf /User/Library/Accounts/new/*.* /User/Library/Accounts/");
	os.execute("chown -R mobile:mobile /User/Library/Accounts/*.*");
end


function CleanAppStore()
	os.execute("rm /User/Library/com.apple.itunesstored/itunesstored_private.sqlitedb-shm");
	os.execute("rm /User/Library/com.apple.itunesstored/itunesstored_private.sqlitedb-wal");

	os.execute("rm /User/Library/com.apple.itunesstored/itunesstored2.sqlitedb-shm");
	os.execute("rm /User/Library/com.apple.itunesstored/itunesstored2.sqlitedb-wal");

	os.execute("rm /User/Library/com.apple.itunesstored/play_activity.sqlitedb-shm");
	os.execute("rm /User/Library/com.apple.itunesstored/play_activity.sqlitedb-wal");

	os.execute("cp -rf /User/Library/com.apple.itunesstored/new/*.* /User/Library/com.apple.itunesstored/");

	os.execute("chown -R mobile:mobile /User/Library/com.apple.itunesstored/*.*");
end

function  SaveLoginOvertimeCount(count)
	writeFileString("/var/mobile/Media/TouchSprite/config/LoginOvertimeCount.txt",tostring(count));  
end

function  LoadLoginOvertimeCount()
	if isFileExist("/var/mobile/Media/TouchSprite/config/LoginOvertimeCount.txt") then
		return readFileString("/var/mobile/Media/TouchSprite/config/LoginOvertimeCount.txt");  
	else
		return 0;
	end
end

function  SaveLog(msg)
	writeFileString("/var/mobile/Media/TouchSprite/config/CleanLog.txt","\n" .. os.date("%Y-%m-%d %H:%M:%S") .. "," .. msg,"a");  
end

function  Reboot()
	os.execute("reboot");  
end


--如果普通版tsp可以加上该段代码
local tsld = loadTSLibrary("aso.tsl") --库加载
if tsld.status == 0 then --验证判断
	dialog("插件加载异常,退出脚本", 0)

	lua_exit();
	return
end
require("ascmd") --需要加载
--以上代码请在脚本开头先调用验证加载，只需加载一次

--local bkvs = ASOVersions()
--toast(bkvs,1);
--if bkvs ~= "1.0.9.3" then --自己上传的文件版本号
--	delFile(userPath().."/plugin/aso.tsl") --删除老版本
--end


--如果普通版tsp可以加上该段代码
local tsld = loadTSLibrary("pretender.tsl") --库加载
if tsld.status == 0 then --验证判断
	dialog("插件加载异常", 0)
	return
end
require("TBackups") --需要加载
--以上代码请在脚本开头先调用验证加载，只需加载一次

--local bkvs = BKVersions()
--if bkvs ~= "1.2.0.7" then --自己上传的文件版本号
--	delFile("/var/mobile/Media/TouchSprite/plugin/pretender.tsl") --删除老版本
--end

require "TSLib";


--找字
--[====[
--内容已复制到剪贴板!
local index = addTSOcrDict("空瓶装水解谜.txt")
toast(index);

--local tab = {
--"000401c1fcc0383fb807060fc0e0c1f81c187703831ce070671c0e0de381cd98703bf00e073e01ffe1c03ffc1807038330e070671c0e0ce381c18e703830ee07061dc0e0c1f81c1f9c0383f3007000000e0000000000000000080001c380e330703ef60e3f8fffffc0ffffc00707000060e0001c1c000fffffe7fffffce60e0188c1c000dc380418071fc3fffff87ffffe0fe301c18cf070318f1c0630f080c6047818ffffc31ffff86300030c0001e180003c00000200000000000020007186030e30e061c6380e70c700ee19c00d833800706ffbffefff7ffdffe8c03c38183707031fc1c0637c300c67e0018c7e03ff8ce07ff18e0ffe33e018c6fe0318fdc0631f1c0c6343818c6078300c0700018080000000000000000003001c00f003803c00700f000e03c001c0f000387c00077e0000ff00701f800e038001c000003bffffff7fffffcc3e000000f000000f800003f800006780001c380007038003c038007003800e0078008007800000600000000000000004000201c001e0781ffc3ffffe0f7ffe07cc6700f98ce01f7fffc0fffff81fc670e3d8ce1c73ffff807fffe1800dc030c7f8063ff700cf7ce01fc59c03e0338c61ffff8c3ffff18619c03fc33807f86700fc0ce000001c00000000000000001c00030300007060010f0ffff0f1fffe0f3fff80c001f060e07f1e1c0ee1e3fff81e7ffe01cfffc053019c1c6079c1ec1e381f8f0301b7c067ffffecfffffd9fffffb01f78060fe780c3cc3c187183c30430306000000@110$空瓶装水解谜$1808$27$165",
--}
--local index = addTSOcrDictEx(tab)
--toast(index);
--请自行更改参数
--1: 0,0,0,0 范围坐标，请自行修改
--2: "787878 , 797979" 偏色,多组或单组.请在偏色列表中选择
--3: 90 匹配精度 【0-100】
local ret = tsOcrText(index, 180, 170, 370, 230, "787878 , 797979", 70)
dialog("识别到的内容:"..ret)
]====] 

local timeOutCount = tonumber(LoadLoginOvertimeCount());
toast("登陆失败次数：" .. timeOutCount,1);

if timeOutCount >1 then
	CleanAccounts();
	mSleep(1000);
	CleanAppStore();
	mSleep(1000);	
	SaveLoginOvertimeCount(0);
	mSleep(1000);
	SaveLog("reboot");
	Reboot();

	return;
end

killVPN();

SlimAppStore();	
clearSafari();
clearAllKeyChains();

local thread = require('thread')
local thread_id1 = thread.create(function()
		return NewDevice();
	end);

local ok,bool,err = thread.wait(thread_id1)
if err then
	toast("一键新机傻逼结束".. err);
	lua_restart();
else
	if ok then
		toast("一键新机正常结束,ret is "..tostring(bool));
	else
		toast("一键新机线程傻逼");
		lua_restart();
	end
end

local thread_id2 = thread.create(function()
		mSleep(10000);
		local killmeCountLimit = 60;
		local killmeCount = 0;

		wufagoumaiIsShown = false;
		local appleiddengluIsShow = false;
		local searchTrendingIsShow = false;

		while true do

			toast("开始杀傻逼……" .. killmeCount,1)

			if killmeCount >= killmeCountLimit then
				toast("超过最大阈值" .. killmeCountLimit .. "，自杀...");
				lua_restart();
			end

			local imageDataList = {};
			imageDataList[1] = {imageName = "存储容量几乎已满.png",x11 = 100,y11 = 470,x12 = 520,y12 = 530,x21 = 190,y21 = 650};
			imageDataList[2] = {imageName = "无法连接到.png",x11 = 120,y11 = 490,x12 = 320,y12 = 550,x21 = 290,y21 = 625};
			--			imageDataList[3] = {imageName = "无法购买.png",x11 = 240,y11 = 440,x12 = 400,y12 = 530,x21 = 320,y21 = 670};
			imageDataList[3] = {imageName = "savepasswordforfree.png",x11 = 120,y11 = 440,x12 = 520,y12 = 490,x21 = 175,y21 = 690};
			imageDataList[4] = {imageName = "theitunesstoreisunable杀傻逼用.png",x11 = 75,y11 = 435,x12 = 560,y12 = 485,x21 = 320,y21 = 700};
			imageDataList[5] = {imageName = "没有被授权使用杀傻逼用.png",x11 = 195,y11 = 525,x12 = 440,y12 = 580,x21 = 320,y21 = 650};
			imageDataList[6] = {imageName = "无法下载项目_杀傻逼.png",x11 = 200,y11 = 475,x12 = 430,y12 = 525,x21 = 190,y21 = 650};
			imageDataList[7] = {imageName = "VPN连接_杀傻逼.png",x11 = 230,y11 = 230,x12 = 410,y12 = 280,x21 = 320,y21 = 460};
			imageDataList[8] = {imageName = "VPN连接_杀傻逼.png",x11 = 230,y11 = 445,x12 = 410,y12 = 495,x21 = 315,y21 = 685};

			findImageClickAreaList(imageDataList);

			local x, y = findImageInRegionFuzzy("xample.png",90, 90, 500, 550, 585,0);
			if x ~= -1 and y ~= -1 then        
				touchDown(180,440);
				mSleep(30);
				touchUp(180,440);
			end	

			local x, y = findImageInRegionFuzzy("appleid登录界面的登录用.png",85,190, 220, 355, 270,0);
			if x ~= -1 and y ~= -1 then        
				if appleiddengluIsShow then
					touchDown(195,475);
					mSleep(30);
					touchUp(195,475);

					appleiddengluIsShow = false;
				else
					appleiddengluIsShow =true;
				end
			end	

			local x, y = findImageInRegionFuzzy("trending_杀傻逼.png",90,225,170,415,285,0);
			if x ~= -1 and y ~= -1 then       
				if searchTrendingIsShow then
					touchDown(170,88);
					mSleep(30);
					touchUp(170,88);

					mSleep(1000);             

					AppstoreTopApp(appid);
					inputText("\b\b\b\b\b\b\b\b\b\b" .. keyword .. "\n"); 
					inputText("\n");

					searchTrendingIsShow = false;
				else
					searchTrendingIsShow =true;
				end
			end	

			local x, y = findImage("无法连接到AppStore.png", 90, 500, 550, 585);
			if x ~= -1 and y ~= -1 then        
				lua_restart();
			end	

			local x, y = findImage("theappstoreistemporarily.png", 70, 560, 560, 615);
			if x ~= -1 and y ~= -1 then        
				lua_restart();
			end	

			local x, y = findImage("cannotconnectto.png", 80, 505, 560, 580);
			if x ~= -1 and y ~= -1 then        
				lua_restart();
			end	


			local x, y = findImage("验证失败.png", 240, 475, 400, 525);
			if x ~= -1 and y ~= -1 then       

				mSleep(1000);

				if globlaIsInDownloading then
					touchDown(450,615);
					mSleep(30);
					touchUp(450,615);
				else
					touchDown(185,615);
					mSleep(30);
					touchUp(185,615);

					lua_restart();
				end
			end	



			if findImageClickArea("无法购买.png",240,440,400,530,320,670) then
				if globlaInstallX ~= 0 and globlaInstallY ~=0 then

					wufagoumaiIsShown = true;
					mSleep(5000);
					touchDown(globlaInstallX,globlaInstallY);
					mSleep(30);
					touchUp(globlaInstallX,globlaInstallY);

					mSleep(1000);
					touchDown(globlaInstallX,globlaInstallY);
					mSleep(30);
					touchUp(globlaInstallX,globlaInstallY);
				end
			end

			killmeCount = killmeCount + 1;
			mSleep(10000);
		end
	end);


resultTemp,globlaAccount,globlaPassword,globlaGameAccount,globlaKeyWords,globlaBunldeName,globlaAppID = getAccountInfo("http://ios.pettostudio.net/AccountInfo.aspx?action=GetIOSFullInfoByStateStr&state=success&configfilename=shuagame2.txt");

if resultTemp then
	ipaUninstall(globlaBunldeName);	

	connectVPN(6);

	closeApp("com.apple.Preferences");
	mSleep(1000);
	openURL("prefs:root=STORE");

	if logoutAppStoreOnUI(180) then
		toast("登出成功",1);
	else
		toast("登出失败",1);
		SaveLoginOvertimeCount(timeOutCount + 1);
		lua_restart();
	end


	if loginAppStoreOnUI(180) then
		toast("登陆成功",1);
		SaveLoginOvertimeCount(0);
	else
		toast("登陆失败",1);
		SaveLoginOvertimeCount(timeOutCount + 1);
		lua_restart();
	end

	closeApp("com.apple.Preferences");
	mSleep(1000);

	globlaIsInDownloading = true;
	local r2 = SerachFuck(globlaKeyWords,globlaAppID);

	if r2 then
		lua_restart();
	else 
		lua_restart();			
	end
else
	lua_restart();
end