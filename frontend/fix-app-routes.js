// 修复APP管理路由问题的脚本
// 在浏览器控制台运行

console.log('=== 开始修复APP管理路由问题 ===');

// 1. 清除路由缓存
if (window.$router) {
    console.log('1. 清除现有路由...');
    
    // 获取所有路由
    const routes = window.$router.getRoutes();
    console.log('当前路由数量:', routes.length);
    
    // 查找app相关路由
    const appRoutes = routes.filter(r => 
        r.path.includes('/app_manage') || 
        r.path.includes('/app_report')
    );
    
    console.log('找到APP相关路由:', appRoutes.length);
    appRoutes.forEach(route => {
        console.log(`- ${route.path} (${route.name})`);
    });
}

// 2. 清除菜单缓存
console.log('2. 清除菜单缓存...');
sessionStorage.removeItem('menuData');
localStorage.removeItem('menuData');

// 3. 清除路由状态
console.log('3. 清除路由状态...');
if (window.$pinia) {
    try {
        const routesStore = window.$pinia._s.get('useRoutesList');
        if (routesStore) {
            routesStore.routesList = [];
            routesStore.isGet = false;
            console.log('路由状态已清除');
        }
    } catch (e) {
        console.log('清除路由状态失败:', e.message);
    }
}

// 4. 强制重新初始化路由
console.log('4. 重新初始化路由...');
setTimeout(() => {
    window.location.reload();
}, 1000);

console.log('=== 修复完成，页面将在1秒后刷新 ===');