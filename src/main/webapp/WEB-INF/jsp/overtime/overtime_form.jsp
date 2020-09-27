<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@taglib prefix="uv" tagdir="/WEB-INF/tags" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="asset" uri="/WEB-INF/asset.tld" %>

<!DOCTYPE html>
<html lang="${language}">
<head>
    <title>
        <c:choose>
            <c:when test="${overtime.id == null}">
                <spring:message code="overtime.record.header.title.new"/>
            </c:when>
            <c:otherwise>
                <spring:message code="overtime.record.header.title.edit"/>
            </c:otherwise>
        </c:choose>
    </title>
    <uv:custom-head/>
    <script>
        window.uv = {};
        window.uv.personId = '<c:out value="${person.id}" />';
        window.uv.apiPrefix = "<spring:url value='/api' />";
    </script>
    <link rel="stylesheet" type="text/css" href="<asset:url value='app_form~overtime_form~sick_note_form.css' />"/>
    <link rel="stylesheet" type="text/css"
          href="<asset:url value='app_form~overtime_form~person_overview~sick_note_form.css' />"/>
    <link rel="stylesheet" type="text/css" href="<asset:url value='npm.jquery-ui-themes.css' />"/>
    <script defer src="<asset:url value='npm.date-fns.js' />"></script>
    <script defer src="<asset:url value='date-fns-localized.js' />"></script>
    <script defer src="<asset:url value='npm.jquery-ui.js' />"></script>
    <script defer src="<asset:url value='npm.jquery-ui-themes.js' />"></script>
    <script defer src="<asset:url value='app_form~overtime_form~sick_note_form.js' />"></script>
    <script defer src="<asset:url value='app_form~overtime_form~person_overview~sick_note_form.js' />"></script>
    <script defer src="<asset:url value='overtime_form.js' />"></script>
</head>
<body>

<spring:url var="URL_PREFIX" value="/web"/>

<uv:menu/>

<c:set var="DATE_PATTERN">
    <spring:message code="pattern.date"/>
</c:set>

<div class="content">
    <div class="container">
        <div class="row">
            <c:choose>
                <c:when test="${overtime.id == null}">
                    <c:set var="ACTION" value="${URL_PREFIX}/overtime"/>
                </c:when>
                <c:otherwise>
                    <c:set var="ACTION" value="${URL_PREFIX}/overtime/${overtime.id}"/>
                </c:otherwise>
            </c:choose>

            <form:form method="POST" action="${ACTION}" modelAttribute="overtime" cssClass="form-horizontal">
                <form:hidden path="id" value="${overtime.id}"/>
                <form:hidden path="person" value="${overtime.person.id}"/>
                <div class="form-section">
                    <div class="col-xs-12">
                        <c:set var="formErrors"><form:errors/></c:set>
                        <c:if test="${not empty formErrors}">
                            <div class="alert alert-danger">
                                <form:errors/>
                            </div>
                        </c:if>
                    </div>
                    <div class="col-xs-12">
                        <legend>
                            <c:choose>
                                <c:when test="${overtime.id == null}">
                                    <spring:message code="overtime.record.new"/>
                                </c:when>
                                <c:otherwise>
                                    <spring:message code="overtime.record.edit"/>
                                </c:otherwise>
                            </c:choose>
                        </legend>
                    </div>
                    <div class="col-md-4 col-md-push-8">
                        <span class="help-block tw-text-sm">
                            <uv:icon-information-circle className="tw-w-4 tw-h-4" solid="true" />
                            <spring:message code="overtime.data.description"/>
                        </span>
                    </div>
                    <div class="col-md-8 col-md-pull-4">
                        <c:if test="${signedInUser.id != overtime.person.id}">
                            <uv:form-group>
                                <jsp:attribute name="label">
                                    <uv:form-label htmlFor="">
                                        <spring:message code="overtime.data.person"/>:
                                    </uv:form-label>
                                </jsp:attribute>
                                <jsp:attribute name="input">
                                    <p class="form-control-static"><c:out value="${overtime.person.niceName}"/></p>
                                </jsp:attribute>
                            </uv:form-group>
                        </c:if>

                        <uv:form-group required="true">
                            <jsp:attribute name="label">
                                <uv:form-label htmlFor="startDate">
                                    <spring:message code="overtime.data.startDate"/>:
                                </uv:form-label>
                            </jsp:attribute>
                            <jsp:attribute name="input">
                                <uv:form-input
                                    id="startDate"
                                    path="startDate"
                                    placeholder="${DATE_PATTERN}"
                                    autocomplete="off"
                                />
                            </jsp:attribute>
                            <jsp:attribute name="error">
                                <form:errors path="startDate" cssClass="error"/>
                            </jsp:attribute>
                        </uv:form-group>

                        <uv:form-group required="true">
                            <jsp:attribute name="label">
                                <uv:form-label htmlFor="endDate">
                                    <spring:message code="overtime.data.endDate"/>:
                                </uv:form-label>
                            </jsp:attribute>
                            <jsp:attribute name="input">
                                <uv:form-input
                                    id="endDate"
                                    path="endDate"
                                    placeholder="${DATE_PATTERN}"
                                    autocomplete="off"
                                />
                            </jsp:attribute>
                            <jsp:attribute name="error">
                                <form:errors path="endDate" cssClass="error"/>
                            </jsp:attribute>
                        </uv:form-group>

                        <uv:form-group required="true">
                            <jsp:attribute name="label">
                                <uv:form-label htmlFor="numberOfHours">
                                    <spring:message code="overtime.data.numberOfHours"/>:
                                </uv:form-label>
                            </jsp:attribute>
                            <jsp:attribute name="input">
                                <uv:form-input
                                    id="numberOfHours"
                                    path="numberOfHours"
                                    placeholder="${DATE_PATTERN}"
                                    autocomplete="off"
                                />
                            </jsp:attribute>
                            <jsp:attribute name="error">
                                <form:errors path="numberOfHours" cssClass="error"/>
                            </jsp:attribute>
                        </uv:form-group>

                        <uv:form-group>
                            <jsp:attribute name="label">
                                <uv:form-label htmlFor="comment">
                                    <spring:message code="overtime.data.comment"/>:
                                </uv:form-label>
                            </jsp:attribute>
                            <jsp:attribute name="input">
                                <span id="char-counter"></span> <spring:message code="action.comment.maxChars"/>
                                <form:textarea path="comment" cssClass="form-control" rows="2"
                                               onkeyup="count(this.value, 'char-counter');"
                                               onkeydown="maxChars(this,200); count(this.value, 'char-counter');"/>
                            </jsp:attribute>
                            <jsp:attribute name="error">
                                <form:errors path="comment" cssClass="error"/>
                            </jsp:attribute>
                        </uv:form-group>
                    </div>
                </div><%-- End of first form section --%>

                <div class="form-section">
                    <div class="col-xs-12">
                        <hr/>
                        <button class="btn btn-success col-xs-12 col-sm-5 col-md-2" type="submit">
                            <spring:message code="action.save"/>
                        </button>
                        <button class="btn btn-default back col-xs-12 col-sm-5 col-md-2 pull-right" type="button">
                            <spring:message code="action.cancel"/>
                        </button>
                    </div>
                </div><%-- End of second form section --%>
            </form:form>
        </div>
        <%-- End of row --%>
    </div>
    <%-- End of container --%>
</div>
<%-- End of content --%>

</body>
</html>
