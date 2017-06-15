local x, y = findImageInRegionFuzzy("获取_ASO_5.png",85, 504,170,620, 290,0);
if x ~= -1 and y ~= -1 then   			
toast("点击啦加号" .. "fyuck",1);
	touchDown(x,y);
	mSleep(30);
	touchUp(x,y);

	toast("点击啦加号" .. "fyuck",1);
	mSleep(1000);

	touchDown(x,y);
	mSleep(30);
	touchUp(x,y);

	globlaInstallX = x +60;
	globlaInstallY = y + 20;

end	

local x, y = findImageInRegionFuzzy("hasdownloaded.png",95,540, 170, 620, 340,0);
if x ~= -1 and y ~= -1 then   
	toast("已经下载过了！！！" .. "fyuck".. x .. ":" ..y,1)

	mSleep(1500);

	touchDown(x,y);
	mSleep(30);
	touchUp(x,y);

	--			return false;
end

local x, y = findImageInRegionFuzzy("install.png",95,470,170, 620, 340,0);
if x ~= -1 and y ~= -1 then   
	toast("Install ！！！" .. "fyuck".. x .. ":" ..y,1)

	mSleep(1500);

	touchDown(x,y);
	mSleep(30);
	touchUp(x,y);
end