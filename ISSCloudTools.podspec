version = "0.1.0";

Pod::Spec.new do |s|
s.name         = "ISSCloudTools"    #存储库名称
s.version      = version      #版本号，与tag值一致
s.summary      = "常用工具类"  #简介
s.description  = "常用UI、分类等集合"  #描述
s.homepage     = "https://github.com/zzxdx/ISSCloudTools"      #项目主页，不是git地址
s.license      = { :type => "MIT", :file => "LICENSE" }   #开源协议
s.author             = { "huangjian" => "951864522@qq.com" }  #作者
s.platform     = :ios, "9.0"                  #支持的平台和版本号
s.source       = { :git => "https://github.com/zzxdx/ISSCloudTools.git", :tag => "#{version}" }         #存储库的git地址，以及tag值


#s.source_files  =  "ISSCloudTools/ISSCloudTools/ISSCloudTool/MacroDefinition.h" #需要托管的源代码路径

s.subspec 'Category' do |cat|
#cat.source_files = 'ISSCloudTools/ISSCloudTools/ISSCloudTool/Category/ISSCategory.h'
    cat.subspec 'Foundation' do |fou|
        fou.source_files = 'ISSCloudTools/ISSCloudTools/ISSCloudTool/Category/Foundation/**/*'
    end
    cat.subspec 'UIKit' do |uik|
        uik.source_files = 'ISSCloudTools/ISSCloudTools/ISSCloudTool/Category/UIKit/**/*'
    end
end

s.subspec 'Tools' do |too|
#too.source_files = 'ISSCloudTools/ISSCloudTools/ISSCloudTool/Tools/**/*'
    too.subspec 'HJCountDown' do |hcd|
    hcd.source_files = 'ISSCloudTools/ISSCloudTools/ISSCloudTool/Tools/HJCountDown/**/*'
    end
    too.dependency "Toast"
end

s.subspec 'UI' do |ui|
    ui.source_files = 'ISSCloudTools/ISSCloudTools/ISSCloudTool/UI/**/*'
    ui.dependency "DZNEmptyDataSet"
    ui.dependency "MJRefresh"
end


s.requires_arc = true #是否支持ARC

#所依赖的第三方库


end


