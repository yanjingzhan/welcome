local x, y = findImageInRegionFuzzy("appleid登录界面的登录用.png",85,190, 220, 350, 270,0);
if x ~= -1 and y ~= -1 then
	toast("appleid登录界面的登录用.png;" .. x .. ":" .. y,1);
else
	toast("找不到");
end