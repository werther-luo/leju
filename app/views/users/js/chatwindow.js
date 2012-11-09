//伸缩框部分的
$(document).ready(function () {
    $('#opciones').hide();
    ChatHidden();
    $('#settings').click(function () {
        $('#opciones').slideToggle();
        $(this).toggleClass("cerrar");
        ChatHidden();

    });
});


//聊天窗部分的
function d$(d) {
    return document.getElementById(d);
}
function gs(d) {
    var t = d$(d);
    if (t) {
        return t.style;
    } else {
        return null;
    }
}
function gs2(d, a) {
    if (d.currentStyle) {
        var curVal = d.currentStyle[a]
    } else {
        var curVal = document.defaultView.getComputedStyle(d, null)[a]
    }
    return curVal;
}
function ChatHidden() {
    // gs("ChatBody").display = "none";
}

function ChatShow() {
    // gs("ChatBody").display = "";
    // gs("ChatHead").display = "";
}
function ChatClose() {
    // gs("main").display = "none";
}

function ChatSend(obj) {
    var o = obj.ChatValue;
    if (o.value.length > 0) {
        d$("ChatContent").innerHTML += "<strong>Akon说：</strong>" + o.value + "<br/>";
        o.value = '';
    }
}

  