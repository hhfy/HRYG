(function($) {
    "use strict";
    var calendarSwitch = (function() {
        function calendarSwitch(element, options) {
            this.settings = $.extend(true, $.fn.calendarSwitch.defaults, options || {});
            this.element = element;
            this.init();
        }
        calendarSwitch.prototype = { /*说明：初始化插件*/
            /*实现：初始化dom结构，布局，分页及绑定事件*/
            init: function() {
                var me = this;
                me.selectors = me.settings.selectors;
                me.sections = me.selectors.sections;
                me.index = me.settings.index;
                me.comfire = me.settings.comfireBtn;

                var html = "<table class='dateZone'><tr><td class='colo'>日</td><td>一</td><td>二</td><td>三</td><td>四</td><td>五</td><td class='colo'>六</td></tr></table>" + "<div class='tbody'></div>"
                $(me.sections).append(html);

                for (var q = 0; q < me.index; q++) {
                    var select = q;
                    $(me.sections).find(".tbody").append("<p class='ny1'></p><table class='dateTable'></table>")
                    var currentDate = new Date();
                    currentDate.setMonth(currentDate.getMonth() + select);
                    var currentYear = currentDate.getFullYear();
                    var currentMonth = currentDate.getMonth();
                    var setcurrentDate = new Date(currentYear, currentMonth, 1);
                    var firstDay = setcurrentDate.getDay();
                    var yf = currentMonth + 1;
                    if (yf < 10) {
                        $(me.sections).find('.ny1').eq(select).text(currentYear + '年' + '0' + yf + '月');
                    } else {
                        $(me.sections).find('.ny1').eq(select).text(currentYear + '年' + yf + '月');
                    }
                    var DaysInMonth = [];
                    if (me._isLeapYear(currentYear)) {
                        DaysInMonth = new Array(31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
                    } else {
                        DaysInMonth = new Array(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
                    }
                    var Ntd = firstDay + DaysInMonth[currentMonth];
                    var Ntr = Math.ceil(Ntd / 7);
                    for (var i = 0; i < Ntr; i++) {
                        $(me.sections).find('.dateTable').eq(select).append('<tr></tr>');
                    };
                    var createTd = $(me.sections).find('.dateTable').eq(select).find('tr');
                    createTd.each(function(index, element) {
                        for (var j = 0; j < 7; j++) {
                            $(this).append('<td></td>')
                        }
                    });
                    var arryTd = $(me.sections).find('.dateTable').eq(select).find('td');
                    for (var m = 0; m < DaysInMonth[currentMonth]; m++) {
                        arryTd.eq(firstDay++).text(m + 1);
                    }
                }
                me._initselected();

            },
            _isLeapYear: function(year) {
                return (year % 4 == 0) && (year % 100 != 0 || year % 400 == 0);
            },
            _initselected: function() {
                var me = this;
                me.comeColor = me.settings.comeColor;
                me.outColor = me.settings.outColor;
                me.daysnumber = me.settings.daysnumber;
                var strDays = new Date().getDate();
                var arry = [];
                var arry1 = [];
                var tds = $(me.sections).find('.dateTable').eq(0).find('td');
                tds.each(function(index, element) {
                    if ($(this).text() == strDays) {
                        var r = index,
                            startDay = $(this).text(),
                            endDay = '',
                            end = '';
                        $(this).append('</br><p class="rz">入住</p>');
                        if ($(this).next().text() != "") {
                            end = $(this).next()
                            endDay = $(this).next().text()
                            $(this).next().append('</br><p class="rz">离店</p>');
                        } else {
                            $(".dateTable").eq(1).find("td").each(function(index, el) {
                                if ($(this).text() != "") {
                                    end = $(this)
                                    endDay = $(this).text()
                                    $(this).append('</br><p class="rz">离店</p>');
                                    return false;
                                }
                            });
                        }
                        var startMonth = $(this).parent('tr').parent('tbody').parent('table').prev('p.ny1').text(),
                            endMonth = end.parent('tr').parent('tbody').parent('table').prev('p.ny1').text()
                        me._callback({
                            start: $.trim(startMonth.replace(/年/g, "-").replace(/月/g, "-") + startDay),
                            end: $.trim(endMonth).replace(/年/g, "-").replace(/月/g, "-") + endDay,
                            day: 1
                        })
                        me._checkColor(me.comeColor, me.outColor)
                    }
                })

                $(me.sections).find('.tbody').find('td').each(function(index, element) {
                    if ($(this).text() != '') {
                        arry.push(element);
                    }
                });
                for (var i = 0; i < strDays - 1; i++) {
                    $(arry[i]).css('color', '#ccc');
                }
                if (me.daysnumber) {
                    //可以在这里添加90天的条件
                    for (var i = strDays - 1; i < strDays + parseInt(me.daysnumber); i++) {
                        arry1.push(arry[i])
                    }
                    for (var i = strDays + parseInt(me.daysnumber); i < $(arry).length; i++) {
                        $(arry[i]).css('color', '#ccc')
                    }
                } else {
                    for (var i = strDays - 1; i < $(arry).length; i++) {
                        arry1.push(arry[i])
                    }
                }
                me._selectDate(arry1)
            },
            _checkColor: function(comeColor, outColor) {
                var me = this;
                var rz = $(me.sections).find('.rz');
                // console.log(rz);
                for (var i = 0; i < rz.length; i++) {
                    if (rz.eq(i).text() == "入住") {
                        rz.eq(i).closest('td').css({
                            'background': comeColor,
                            'color': '#fff'
                        });
                    } else {
                        rz.eq(i).closest('td').css({
                            'background': outColor,
                            'color': '#fff'
                        });
                    }
                }

            },
            _callback: function(param) {
                var me = this;
                if (me.settings.callback && $.type(me.settings.callback) === "function") {
                    me.settings.callback(param);
                }
            },
            _selectDate: function(arry1) {
                var me = this;
                me.comeColor = me.settings.comeColor;
                me.outColor = me.settings.outColor;
                me.comeoutColor = me.settings.comeoutColor;
                me.sections = me.selectors.sections;

                var flag = 0;
                var first;
                var sum;
                var second;
                var start = ''
                $(arry1).on('click', function(index) {
                    index.stopPropagation();
                    //第一次点击
                    if (flag == 0) {
                        $(me.sections).find('.hover').remove();
                        $(me.sections).find('.tbody').find('p').remove('.rz');
                        $(me.sections).find('.tbody').find('br').remove();
                        $(arry1).css({
                            'background': '#fff',
                            'color': '#333333'
                        });
                        $(this).append('<p class="rz">入住</p>')
                        first = $(arry1).index($(this));
                        me._checkColor(me.comeColor, me.outColor)
                        flag = 1;
                        //显示提示：选择离店日期
                        $(me.sections).find('.rz').each(function(index, element) {
                            if ($(this).text() == '入住') {
                                var day = parseInt($(this).parent().text().replace(/[^0-9]/ig, "")) //截取字符串中的数字
                                if(day < 10){
                                    day = "0" + day;
                                }
                                var startDayArrays = $(this).parents('table').prev('p').text().split('');
                                var startDayArrayYear = [];
                                var startDayArrayMonth = [];
                                var startDayYear = "";
                                var startDayMonth = "";
                                for (var i = 0; i < me.index; i++) {
                                    var select = i;
                                    startDayArrayYear.push(startDayArrays[select])
                                }
                                startDayYear = startDayArrayYear.join('');
                                for (var i = 5; i < 7; i++) {
                                    startDayArrayMonth.push(startDayArrays[i])
                                }
                                startDayMonth = startDayArrayMonth.join('');
                                //添加入住到input
                                start = (startDayYear + '-' + startDayMonth + '-' + day);
                                $(this).parent('td').append('<span class="hover ruzhu_hover">选择离店日期</span>');
                                $(this).parent('td').css('position', 'relative');
                            }
                        });
                        $('.hover').css({
                            'position': 'absolute',
                            'left': '-17px',
                            'top': '0px'
                        })
                        $('.ruzhu_hover').css({
                            'width':'100%',
                            'height':'41px',
                            'left': '0px',
                            'top': '-45px',
                            'background':'#434949',
                            'color':'#fff',
                            'z-index':'2'
                        })
                    } else if (flag == 1) { //第二次点击
                        $(me.sections).find('.rz').each(function(index, element) {
                            if ($(this).text() == '入住') {
                                var day = parseInt($(this).parent().text().replace(/[^0-9]/ig, "")) //截取字符串中的数字
                                if(day < 10){
                                    day = "0" + day;
                                }
                                var startDayArrays = $(this).parents('table').prev('p').text().split('');
                                var startDayArrayYear = [];
                                var startDayArrayMonth = [];
                                var startDayYear = "";
                                var startDayMonth = "";
                                for (var i = 0; i < me.index; i++) {
                                    var select = i;
                                    startDayArrayYear.push(startDayArrays[select])
                                }
                                startDayYear = startDayArrayYear.join('');
                                for (var i = 5; i < 7; i++) {
                                    startDayArrayMonth.push(startDayArrays[i])
                                }
                                startDayMonth = startDayArrayMonth.join('');
                                //添加入住到input
                                start = (startDayYear + '-' + startDayMonth + '-' + day);
                                $(this).parent('td').find('.ruzhu_hover').remove();
                                $(this).parent('td').css('position', 'relative');
                            }
                        });
                        flag = 0;
                        second = $(arry1).index($(this))
                        //如果第一次点击比第二次大，则不显示
                        if(first >= second){
                            $(me.sections).find('.hover').remove();
                            $(me.sections).find('.tbody').find('p').remove('.rz');
                            $(me.sections).find('.tbody').find('br').remove();
                            $(arry1).css({
                                'background': '#fff',
                                'color': '#333333'
                            });
                            $(this).append('<p class="rz">入住</p>')
                            first = $(arry1).index($(this));
                            me._checkColor(me.comeColor, me.outColor)
                            flag = 1;
                            //显示提示：选择离店日期
                            $(me.sections).find('.rz').each(function(index, element) {
                                if ($(this).text() == '入住') {
                                    var day = parseInt($(this).parent().text().replace(/[^0-9]/ig, "")) //截取字符串中的数字
                                    if(day < 10){
                                        day = "0" + day;
                                    }
                                    var startDayArrays = $(this).parents('table').prev('p').text().split('');
                                    var startDayArrayYear = [];
                                    var startDayArrayMonth = [];
                                    var startDayYear = "";
                                    var startDayMonth = "";
                                    for (var i = 0; i < me.index; i++) {
                                        var select = i;
                                        startDayArrayYear.push(startDayArrays[select])
                                    }
                                    startDayYear = startDayArrayYear.join('');
                                    for (var i = 5; i < 7; i++) {
                                        startDayArrayMonth.push(startDayArrays[i])
                                    }
                                    startDayMonth = startDayArrayMonth.join('');
                                    //添加入住到input
                                    start = (startDayYear + '-' + startDayMonth + '-' + day);
                                    $(this).parent('td').append('<span class="hover ruzhu_hover">选择离店日期</span>');
                                    $(this).parent('td').css('position', 'relative');
                                }
                            });
                            $('.hover').css({
                                'position': 'absolute',
                                'left': '-17px',
                                'top': '0px'
                            })
                            $('.ruzhu_hover').css({
                                'width':'100%',
                                'height':'41px',
                                'left': '0px',
                                'top': '-45px',
                                'background':'#434949',
                                'color':'#fff',
                                'z-index':'2'
                            });
                            return;
                        }
                        sum = Math.abs(second - first);
                        if (sum == 0) {
                            sum = 1;
                        }
                        
                        if (first < second) {
                            $(this).append('<p class="rz">离店</p>')
                            first = first + 1;
                            for (first; first < second; first++) {
                                $(arry1[first]).css({
                                    'background': me.comeoutColor,
                                    'color': '#333333'
                                });
                            }
                        } else if (first == second) {

                            /*$(me.sections).find('.rz').text('入住');
                            $(this).append('<p class="rz">离店</p>');
                            $(this).find('.rz').css('font-size', '12px');
                            var e = $(this).text().replace(/[^0-9]/ig, "");
                            var c, d;
                            var a = new Array();
                            var b = new Array();
                            var f;
                            var same = $(this).parents('table').prev('p').text().replace(/[^0-9]/ig, "").split('');
                            for (var i = 0; i < 4; i++) {
                                a.push(same[i]);

                            }
                            c = a.join('');
                            for (var j = 4; j < 6; j++) {
                                b.push(same[j]);
                            }
                            d = b.join('');

                            f = c + '-' + d + '-' + e;
                            $("#startDate").val(f);*/

                        } else if (first > second) {

                            $(me.sections).find('.rz').text('离店');
                            $(this).append('<p class="rz">入住</p>')
                            second = second + 1;
                            for (second; second < first; second++) {
                                $(arry1[second]).css({
                                    'background': me.comeoutColor,
                                    'color': '#333333'
                                });
                            }
                        }
                        $(me.sections).find('.rz').each(function(index, element) {
                            if ($(this).text() == '离店') {
                                var _day = $(this).parent().text().split('离')[0];
                                if(_day < 10){
                                    _day = "0" + _day;
                                }
                                var endDayArrays = $(this).parents('table').prev('p').text().split('');
                                var endDayArrayYear = [];
                                var endDayArrayMonth = [];
                                var endDayYear = "";
                                var endDayMonth = "";
                                for (var i = 0; i < 4; i++) {
                                    endDayArrayYear.push(endDayArrays[i])
                                }
                                endDayYear = endDayArrayYear.join('');
                                for (var i = 5; i < 7; i++) {
                                    endDayArrayMonth.push(endDayArrays[i])
                                }
                                endDayMonth = endDayArrayMonth.join('');
                                $(this).parent('td').append('<span class="hover lidian_hover">共' + sum + '晚</span>');
                                $(this).parent('td').css('position', 'relative');
                                me._callback({
                                    start: start,
                                    end: endDayYear + '-' + endDayMonth + '-' + _day,
                                    day: sum
                                });
                            }
                        });

                        $('.hover').css({
                            'position': 'absolute',
                            'left': '-17px',
                            'top': '0px'
                        })
                        $('.ruzhu_hover').css({
                            'width':'200%',
                            'left': '0px',
                            'top': '-24px',
                            'background':'#434949',
                            'color':'#fff',
                            'z-index':'2'
                        })
                        $('.lidian_hover').css({
                            'width':'100%',
                            'left': '0px',
                            'top': '-24px',
                            'background':'#434949',
                            'color':'#fff'
                        })
                        // me._slider('firstSelect')

                        
                        var myweek = ["星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"];

                        var st = new Date($('#startDate').val());
                        var en = new Date($('#endDate').val());
                        $('.week').text(myweek[st.getDay()])
                        $('.week1').text(myweek[en.getDay()])
                        me._checkColor(me.comeColor, me.outColor)



                    }
                    //第二次点击结束

                })
            }

        }
        return calendarSwitch;
    })();
    $.fn.calendarSwitch = function(options) {
        return this.each(function() {
            var me = $(this),
                instance = me.data("calendarSwitch");

            if (!instance) {
                me.data("calendarSwitch", (instance = new calendarSwitch(me, options)));
            }

            if ($.type(options) === "string") return instance[options]();
        });
    };
    $.fn.calendarSwitch.defaults = {
        selectors: {
            sections: "#calendar"
        },
        index: 4,
        //展示的月份个数
        animateFunction: "toggle",
        //动画效果
        controlDay: false,
        //知否控制在daysnumber天之内，这个数值的设置前提是总显示天数大于90天
        daysnumber: "30",
        //控制天数
        comeColor: "blue",
        //入住颜色
        outColor: "red",
        //离店颜色
        comeoutColor: "#0cf",
        //入住和离店之间的颜色
        callback: "",
        //回调函数
        comfireBtn: '.comfire' //确定按钮的class或者id

    };
})(jQuery);