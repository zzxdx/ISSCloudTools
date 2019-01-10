version = "0.1.2";

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


s.source_files  =  "ISSCloudTools/ISSCloudTools/ISSCloudTool/**/*" #需要托管的源代码路径

s.subspec 'Category' do |cat|
#cat.source_files = 'ISSCloudTools/ISSCloudTools/ISSCloudTool/Category/ISSCategory.h'
    cat.subspec 'Foundation' do |fou|
        fou.source_files = 'ISSCloudTools/ISSCloudTools/ISSCloudTool/Category/Foundation/*.{h,m}'
    end
    cat.subspec 'UIKit' do |uik|
        uik.source_files = 'ISSCloudTools/ISSCloudTools/ISSCloudTool/Category/UIKit/*.{h,m}'
    end
end

s.subspec 'Tools' do |too|
too.source_files = 'ISSCloudTools/ISSCloudTools/ISSCloudTool/Tools/*.{h,m}'
    too.subspec 'HJCountDown' do |hcd|
    hcd.source_files = 'ISSCloudTools/ISSCloudTools/ISSCloudTool/Tools/HJCountDown/*.{h,m}'
    end
too.dependency "Toast"
end



s.subspec 'UI' do |ui|
ui.source_files = 'ISSCloudTools/ISSCloudTools/ISSCloudTool/UI/*.{h,m}'
        ui.subspec 'Base' do |bas|
        bas.source_files = 'ISSCloudTools/ISSCloudTools/ISSCloudTool/UI/Base/*.{h,m}'
        bas.dependency "DZNEmptyDataSet"
        bas.dependency "MJRefresh"
        end
end

s.frameworks = "Foundation", "UIKit"
s.requires_arc = true #是否支持ARC

#所依赖的第三方库


end


