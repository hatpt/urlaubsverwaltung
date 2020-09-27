<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@taglib prefix="uv" tagdir="/WEB-INF/tags" %>

<%@attribute name="id" type="java.lang.String" required="true" %>
<%@attribute name="actionUrl" type="java.lang.String" required="true" %>

<c:set var="FILTER_DATE_PATTERN">
    <spring:message code="pattern.date"/>
</c:set>

<div id="${id}" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="filterModalLabel"
     aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                    <uv:icon-x-circle className="tw-w-8 tw-h-8" solid="true" />
                </button>
                <h4 id="filterModalLabel" class="modal-title"><spring:message code="filter.title"/></h4>
            </div>
            <form:form method="POST" action="${actionUrl}" modelAttribute="period" class="form-horizontal">
                <div class="modal-body">
                    <uv:form-group required="true">
                        <jsp:attribute name="label">
                            <uv:form-label htmlFor="startDate">
                                <spring:message code="filter.period.startDate" />:
                            </uv:form-label>
                        </jsp:attribute>
                        <jsp:attribute name="input">
                            <uv:form-input
                                id="startDate"
                                path="startDate"
                                placeholder="${FILTER_DATE_PATTERN}"
                            />
                        </jsp:attribute>
                    </uv:form-group>
                    <uv:form-group required="true">
                        <jsp:attribute name="label">
                            <uv:form-label htmlFor="endDate">
                                <spring:message code="filter.period.endDate" />:
                            </uv:form-label>
                        </jsp:attribute>
                        <jsp:attribute name="input">
                            <uv:form-input
                                id="endDate"
                                path="endDate"
                                placeholder="${FILTER_DATE_PATTERN}"
                            />
                        </jsp:attribute>
                    </uv:form-group>
                </div>
                <div class="modal-footer">
                    <button class="btn btn-primary is-sticky" type="submit">
                        <spring:message code="action.confirm"/>
                    </button>
                </div>
            </form:form>
        </div>
    </div>
</div>
