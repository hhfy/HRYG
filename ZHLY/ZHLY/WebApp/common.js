
"use strict";
window.onload = function(){
    var loadings = $('.loading-box')
    loadings.fadeOut(500)
}
/**
 * 抛出接口
 */
var common = {
    checkBrower: function () {
        var u = navigator.userAgent, app = navigator.appVersion;
        return {
            trident: u.indexOf('Trident') > -1, //IE内核
            presto: u.indexOf('Presto') > -1, //opera内核
            webKit: u.indexOf('AppleWebKit') > -1, //苹果、谷歌内核
            gecko: u.indexOf('Gecko') > -1 && u.indexOf('KHTML') == -1,//火狐内核
            mobile: !!u.match(/AppleWebKit.*Mobile.*/), //是否为移动终端
            ios: !!u.match(/\(i[^;]+;( U;)? CPU.+Mac OS X/), //ios终端
            android: u.indexOf('Android') > -1 || u.indexOf('Adr') > -1, //android终端
            iPhone: u.indexOf('iPhone') > -1 , //是否为iPhone或者QQHD浏览器
            iPad: u.indexOf('iPad') > -1, //是否iPad
            webApp: u.indexOf('Safari') == -1, //是否web应该程序，没有头部与底部
            weixin: u.indexOf('MicroMessenger') > -1, //是否微信 （2015-01-22新增）
            qq: u.match(/\sQQ/i) == " qq" //是否QQ
        };
    },
    filters: {
        empty: function (str, val) {
            return !str ? val : str
        }
    },
    /**
     * 常用前端页面正则校验
     * */
    checked : {
        //手机号码
        mobile   :/^1\d{10}$/,
        //帐号，字母开头，可接数字跟_,6-18长度
        account  :/^[a-zA-Z][a-zA-Z0-9_]{5,17}$/,
        //密码长度在6-18
        password :/^\w{6,18}$/,
        //数字
        number   :/^[0-9]*$/,
        //价格
        price    :/^(([1-9]\d{0,9})|0)(\.\d{1,2})?$/,
        //邮箱
        email    : /^[a-z0-9!#$%&'*+\/=?^_`{|}~.-]+@[a-z0-9]([a-z0-9-]*[a-z0-9])?(\.[a-z0-9]([a-z0-9-]*[a-z0-9])?)*$/i,
        //url
        url      : /(http|https):\/\/[\w\-_]+(\.[\w\-_]+)+([\w\-\.,@?^=%&:/~\+#]*[\w\-\@?^=%&/~\+#])?/
    },
    is_mobile: function(value) {
        return this.checked.mobile.test(value);
    },
    is_account: function(value) {
        return this.checked.account.test(value);
    },
    is_password: function(value) {
        return this.checked.password.test(value);
    },
    is_number: function(value) {
        return this.checked.number.test(value);
    },
    is_price: function(value) {
        return this.checked.price.test(value);
    },
    is_email: function(value) {
        return this.checked.email.test(value);
    },
    is_url: function (value) {
        return this.checked.url.test(value);
    },
    /**
     * 获取当前时间
     * format： 类型
     */
    nowTime: function (format) {
        format = format || 'Y-m-d'

        //timestamp是整数，否则要parseInt转换,不会出现少个0的情况
        var  now = new Date();
        var year = this.complement(now.getFullYear())
        var month = this.complement(now.getMonth() + 1)
        var date = this.complement(now.getDate())
        var hour = this.complement(now.getHours())
        var minute = this.complement(now.getMinutes())
        var second = this.complement(now.getSeconds())
        switch (format) {
            case 'Y-m-d H:i:s':
                return year + "-" + month + "-" + date + " " + hour + ":" + minute + ":" + second
            case 'Y/m/d H:i:s':
                return year + "/" + month + "/" + date + " " + hour + ":" + minute + ":" + second
            case 'Y-m-d H:i':
                return year + "-" + month + "-" + date + " " + hour + ":" + minute
            case 'Y-m-d':
                return year + "-" + month + "-" + date
            case 'H:i:s':
                return hour + ":" + minute + ":" + second
            case 'H:i':
                return hour + ":" + minute
            default:
                return year + "-" + month + "-" + date + " " + hour + ":" + minute + ":" + second
        }
    },

    /**
     * 获取当前控制器路径
     * 参数说明
     * fun_name：方法名
     * level: 项目层级，默认3级
     * */
    getPathName: function(fun_name, level){
        if (!fun_name) return;
        level = level || 3
        var t_pathname = window.location.pathname,
            n_pathname = '';
        if (fun_name.split('/').length > 1) {
            return fun_name
        }
        t_pathname = t_pathname.substr(1);
        var name = t_pathname.split('/');
        var i = 0;
        if (name[0] == 'index.php') {
            level += 1
        }
        for(i; i < level; i++) {
            n_pathname +=  '/' + name[i]
        }
        return n_pathname + '/' + fun_name;
    },
    /**
     *  设置AJAX数据请求
     *  @param  {[String]} url      [请求路径]
     *  @param  {[JSON]}   data     [发送参数]
     *  @param  {[Object]} callback [成功后的回调函数]
     *  @param  {[String]} type     [发送请求类型('post','get')]
     *  @return {[JSON]}            [服务器返回json数据]
     */
    ajaxSubmit: function (url, data, callback, type) {
        var _this = this
        type = type || 'get';
        if (typeof (callback) != "function") {
            callback = function () { }
        }
        $.ajax({
            url: url,
            async: false,
            type: type,
            data: data,
            // dataType: 'JSON',
            beforeSend: function (XMLHttpRequest) {
                // console.log(XMLHttpRequest)
            },
            complete: function (XMLHttpRequest) {
                // console.log(XMLHttpRequest)
                /*if (!XMLHttpRequest.responseText.match("^\{(.+:.+,*){1,}\}$")) {
                    console.log(XMLHttpRequest.responseText)
                } else {
                    var data = $.parseJSON(XMLHttpRequest.responseText);
                    //#todo 统一错误处理
                    if(data.code != 200) {
                        return false
                    }
                }*/
            },
            success: callback,
            error: function (req) {
                console.log(req)
            }
        });
    },
    /**
     *  设置get请求
     *  @param  {[String]} url      [请求路径]
     *  @param  {[JSON]}   data     [发送参数]
     *  @param  {[Object]} callback [成功后的回调函数]
     *  @return {[JSON]}            [服务器返回json数据]
     */
    DataGet: function (url, data, callback) {
        this.ajaxSubmit(url, data, callback, 'get')
    },
    /**
     *  设置post请求
     *  @param  {[String]} url      [请求路径]
     *  @param  {[JSON]}   data     [发送参数]
     *  @param  {[Object]} callback [成功后的回调函数]
     *  @return {[JSON]}            [服务器返回json数据]
     */
    DataPost: function (url, data, callback) {
        this.ajaxSubmit(url, data, callback, 'post')
    },
    /**
     * 不足10位补零
     * 参数：num
     */
    complement: function (num) {
        num = Number(num)
        return num < 10 ? '0' + num : num;
    },
    /**
     * 获取url中的参数
     * @param name
     * @returns {*}
     */
    getQueryString: function(name) {
        var reg = new RegExp('(^|&)' + name + '=([^&]*)(&|$)', 'i');
        var r = window.location.search.substr(1).match(reg);
        if (r != null) {
            return decodeURIComponent(r[2]);
            }
        return null;
    }
};