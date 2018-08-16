version = "0.0.2";

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
s.source_files  =  "ISSCloudTools/ISSCloudTools/ISSCloudTool/*" #需要托管的源代码路径
s.requires_arc = true #是否支持ARC

s.dependency "MBProgressHUD"    #所依赖的第三方库，没有就不用写
s.dependency "AFNetworking"
s.dependency "Toast"



end


