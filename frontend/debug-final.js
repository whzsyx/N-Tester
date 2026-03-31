// 最终调试脚本 - 在浏览器控制台运行
console.log('=== APP管理路由最终调试 ===');

// 1. 检查当前环境
console.log('1. 环境检查:');
console.log('- 当前URL:', window.location.href);
console.log('- 是否生产环境:', process?.env?.NODE_ENV === 'production');

// 2. 检查路由器状态
console.log('\n2. 路由器状态:');
if (window.$router) {
    const currentRoute = window.$router.currentRoute.value;
    console.log('- 当前路由:', currentRoute.path);
    console.log('- 路由参数:', currentRoute.params);
    console.log('- 路由查询:', currentRoute.query);
    
    const allRoutes = window.$router.getRoutes();
    console.log('- 总路由数:', allRoutes.length);
    
    const appRoutes = allRoutes.filter(r => 
        r.path.includes('/app_manage') || 
        r.path.includes('/app_report') ||
        r.name?.toString().toLowerCase().includes('app')
    );
    
    console.log('- APP相关路由数:', appRoutes.length);
    appRoutes.forEach(route => {
        console.log(`  * ${route.path} -> ${route.name} (组件: ${route.component ? '✅' : '❌'})`);
    });
} else {
    console.error('❌ 路由器未找到');
}

// 3. 检查Pinia状态
console.log('\n3. Pinia状态:');
if (window.$pinia) {
    try {
        const routesStore = window.$pinia._s.get('useRoutesList');
        if (routesStore) {
            console.log('- 路由列表长度:', routesStore.routesList?.length || 0);
            console.log('- 是否已获取:', routesStore.isGet);
            
            const appMenus = routesStore.routesList?.filter(r => 
                r.path?.includes('app') || r.meta?.title?.includes('APP')
            ) || [];
            console.log('- APP菜单数:', appMenus.length);
            appMenus.forEach(menu => {
                console.log(`  * ${menu.meta?.title}: ${menu.path} -> ${menu.component}`);
            });
        }
        
        const menuStore = window.$pinia._s.get('useMenuInfo');
        if (menuStore) {
            console.log('- 菜单数据长度:', menuStore.menuData?.length || 0);
        }
    } catch (e) {
        console.error('获取Pinia状态失败:', e);
    }
} else {
    console.error('❌ Pinia未找到');
}

// 4. 检查本地存储
console.log('\n4. 本地存储:');
const menuData = sessionStorage.getItem('menuData') || localStorage.getItem('menuData');
if (menuData) {
    try {
        const menus = JSON.parse(menuData);
        console.log('- 缓存菜单数:', menus.length);
        
        const findAppMenus = (menuList) => {
            let appMenus = [];
            menuList.forEach(menu => {
                if (menu.path?.includes('app') || menu.meta?.title?.includes('APP')) {
                    appMenus.push(menu);
                }
                if (menu.children?.length > 0) {
                    appMenus = appMenus.concat(findAppMenus(menu.children));
                }
            });
            return appMenus;
        };
        
        const appMenus = findAppMenus(menus);
        console.log('- APP菜单数:', appMenus.length);
        appMenus.forEach(menu => {
            console.log(`  * ${menu.meta?.title}: ${menu.path} -> ${menu.component}`);
        });
    } catch (e) {
        console.error('解析菜单数据失败:', e);
    }
} else {
    console.log('- 无缓存菜单数据');
}

// 5. 尝试导航到APP页面
console.log('\n5. 导航测试:');
const testNavigation = async () => {
    const testPaths = [
        '/app_manage/package',
        '/app_manage/automation', 
        '/app_manage/images',
        '/app_manage/results'
    ];
    
    for (const path of testPaths) {
        try {
            console.log(`测试导航到: ${path}`);
            await window.$router.push(path);
            await new Promise(resolve => setTimeout(resolve, 100));
            
            const currentPath = window.$router.currentRoute.value.path;
            if (currentPath === path) {
                console.log(`✅ 导航成功: ${path}`);
            } else {
                console.log(`❌ 导航失败: ${path} -> 实际: ${currentPath}`);
            }
        } catch (e) {
            console.error(`❌ 导航异常: ${path}`, e);
        }
    }
};

// 6. 提供修复建议
console.log('\n6. 修复建议:');
console.log('如果路由未注册或组件未加载，请尝试:');
console.log('1. 清除缓存: sessionStorage.clear(); localStorage.clear();');
console.log('2. 重置路由状态: 见上面的Pinia状态重置');
console.log('3. 强制刷新: window.location.reload();');
console.log('4. 检查网络: 确保后端API正常');
console.log('5. 检查控制台: 查看是否有组件加载错误');

// 运行导航测试
if (window.$router) {
    console.log('\n开始导航测试...');
    testNavigation();
}