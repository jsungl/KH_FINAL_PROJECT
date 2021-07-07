<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<%-- header --%>
<jsp:include page="/WEB-INF/views/common/header.jsp">
	<jsp:param value="나홀로 나들이" name="title" />
</jsp:include>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/memberEnroll.css" />

<div id="enroll-header" class="mx-auto text-center" style="margin-top:50px;">
<h2>휴대폰 수정</h2>
</div>

<div id="enroll-container" class="mx-auto mt-4 mb-4 text-center">
	<form:form 
		name="memberEnrollFrm" 
		action="${pageContext.request.contextPath}/mypage/memberUpdate.do" 
		method="post">
		<table class="mx-auto mb-4">
		<input type="hidden" name="id" value="${principal.id}" />
		
            <tr>
                <th>휴대폰</th>
                <td>
	                <div id="memberPhone-container">	
	                    <input type="tel" class="form-control" placeholder="(-없이)01012345678" name="phone" id="phone" maxlength="11" required style="margin-bottom: 0; width: 320px;">
	                    <span class="guide ok" id="phoneOk">이 번호는 사용가능합니다.</span>
			            <span class="guide error" id="phoneError">이미 가입되있는 번호입니다.</span>
	                </div>
                </td>
                <td>
                    <button class="btn btn-primary btn-sm" type="button" name="phoneVerifyBtn" id="phoneVerifyBtn" style="background-color:#ce8832; border-color: #d39e34;">인증번호 전송</button>
                </td>
            </tr>
            <tr>
                <th></th>
                <td>
                    <input type="text" class="form-control" placeholder="인증번호 입력" name="phoneVerifyNum" id="phoneVerifyNum">
                	<input type="hidden" name="phoneVerifyCode" id="phoneVerifyCode" value="0"/>
                	<input type="hidden" name="phoneValid" id="phoneValid" value="0"/>
                	<input type="hidden" name="phoneVerifyChk" id="phoneVerifyChk" value="0"/>                	
                </td>
            </tr>
            
			
		</table>
		<input type="submit" class="btn btn-primary btn-lg" value="수정" style="width:30%">
		<input type="reset" class="btn btn-secondary btn-lg" id="cancelBtn" value="취소" style="width:30%">
	</form:form>
</div>

<script>

$(document).ready(function(){
	var preference0 = $('input:checkbox[id="preference0"]');
	var preference1 = $('input:checkbox[id="preference1"]');
	var preference2 = $('input:checkbox[id="preference2"]');
	var preference3 = $('input:checkbox[id="preference3"]');
	var preference4 = $('input:checkbox[id="preference4"]');
	var preferenceArr = [preference0, preference1, preference2, preference3, preference4];
	var arr = new Array();

	<c:forEach items="${principal.preference}" var="preference" varStatus="status">
	arr[${status.index}] = '${preference}';
	</c:forEach>

	for(var i = 0; i < arr.length; i++){
		for(var j = 0; j < preferenceArr.length; j++){
			if(arr[i] == preferenceArr[j].val()){
				preferenceArr[i].attr("checked", true);
			}
		}
	}
});

function showPwdFrm(){
	$('#showPwdFrm1').remove();
	$('#showPwdFrm2').html('<th>패스워드</th><td>'
			+'<input type="password" class="form-control" name="password" id="password" required></td>');
	$('#showPwdFrm3').html('<th>패스워드확인</th><td>'
			+'<input type="password" class="form-control" id="passwordCheck" required></td>');
}

function showPhoneFrm(){
	$('#showPFrm').remove();
	$('#showPFrm2').html('<th>휴대폰</th><td>'
			+'<input type="tel" class="form-control" placeholder="(-없이)01012345678" name="phone" id="phone" value="${principal.phone}" maxlength="11" required style="margin-bottom: 0;">'
			+'</td><td><button class="btn btn-primary btn-sm" type="button" name="phoneVerifyBtn" id="phoneVerifyBtn">인증번호 전송</button></td>');
	$('#showPFrm3').html('<th></th><td>'
			+'<input type="text" class="form-control" placeholder="인증번호 입력" name="phoneVerifyNum" id="phoneVerifyNum">'
			+'<input type="hidden" name="phoneVerifyCode" id="phoneVerifyCode" value="0"/>'
			+'<input type="hidden" name="phoneValid" id="phoneValid" value="0"/></td>');
}

$("#cancelBtn").click(e => {
	//location.href = '${empty header.referer || fn:contains(header.referer, '/member/memberLogin.do') ? pageContext.request.contextPath : header.referer}';
	location.href = '${header.referer}';
	//location.href = "${pageContext.request.contextPath}/member/memberLogin.do";
});


//휴대폰전화번호 입력
$("#phone").keyup(e => {
	const phone = $(e.target).val();
	const $phoneError = $("#phoneError");
	const $phoneOk = $("#phoneOk");
	const $phoneValid = $("#phoneValid");

	if(phone.length < 11){
		$phoneError.hide();
		$phoneOk.hide();
		$phoneValid.val(0); //다시 작성하는 경우 대비
		return;
	}

	$.ajax({
		url: "${pageContext.request.contextPath}/member/checkPhoneDuplicate2.do",
		data: {phone},
		success: (data) => {
			console.log(data);
			const {available} = data;
			if(available){
				$phoneOk.show();
				$phoneError.hide();
				$phoneValid.val(1);
			}else{
				$phoneOk.hide();
				$phoneError.show();
				$phoneValid.val(0);
			}
		},
		error: console.log
	});
	
});



//핸드폰 인증번호 입력
$("#phoneVerifyNum").keyup(e => {
	const phoneVerifyNum = $(e.target).val();
	const phoneVerifyCode = $("#phoneVerifyCode").val();

	if(phoneVerifyNum.length < 4){
		$("#phoneValid").val(0);
		return;
	}

	if(phoneVerifyNum == phoneVerifyCode){
		$("#phoneValid").val(1);
	}else{
		$("#phoneValid").val(0);
	}
	
});

//핸드폰 인증버튼 클릭
$("#phoneVerifyBtn").click(e => {

	 var number = Math.floor(Math.random() * 100000) + 100000;
     if(number>100000){
        number = number - 10000;
     }
     console.log(number);
     $("#phoneVerifyCode").val(number);
     
	 const to = $("#phone").val();
	 const code = $("#phoneVerifyCode").val();
	 
	 if(to == "" || to == null){
		alert("전화번호 입력후 전송버튼을 눌러주세요");
		$("#phoneValid").val(0);
	 }else{

		$.ajax({
			url: "${pageContext.request.contextPath}/mypage/sendSms.do",
			data: {to,code},
			success: (data) => {
				console.log(data);
				const {result} = data;
				if(result){
					alert("인증번호가 전송되었습니다. 확인후 입력해주세요");
				}else{
					alert("인증번호 전송에 실패하였습니다.");
				}
			},
			error: console.log
		});
	 }

});


//회원가입 폼 전송
$("[name=memberEnrollFrm]").submit(function(){

	var $phoneValid = $("#phoneValid");
	var $phoneVerifyNum = $("#phoneVerifyNum");
	var $phoneVerifyCode = $("#phoneVerifyCode")
	if($phoneVerifyCode.val() == 0){
		alert("인증을 먼저 해주세요")
		return false;
	}else if($phoneValid.val() == 0){
		alert("인증번호가 일치하지않습니다. 다시 확인해주세요")
		$phoneVerifyNum.focus();
		return false;
	}
	
	return true;
});
</script>



<%-- footer --%>
<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>