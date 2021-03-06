package org.synyx.urlaubsverwaltung.application.web;

import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;
import org.springframework.validation.Errors;
import org.springframework.validation.Validator;


/**
 * Validates the content of {@link ApplicationCommentForm}s.
 */
@Component
public class ApplicationCommentValidator implements Validator {

    private static final int MAX_CHARS = 200;

    private static final String ATTRIBUTE_TEXT = "text";

    private static final String ERROR_REASON = "error.entry.mandatory";
    private static final String ERROR_LENGTH = "error.entry.tooManyChars";

    @Override
    public boolean supports(Class<?> clazz) {

        return ApplicationCommentForm.class.equals(clazz);
    }


    @Override
    public void validate(Object target, Errors errors) {

        ApplicationCommentForm comment = (ApplicationCommentForm) target;

        String text = comment.getText();
        boolean hasText = StringUtils.hasText(text);

        if (!hasText && comment.isMandatory()) {
            errors.rejectValue(ATTRIBUTE_TEXT, ERROR_REASON);
        }

        if (hasText && text.length() > MAX_CHARS) {
            errors.rejectValue(ATTRIBUTE_TEXT, ERROR_LENGTH);
        }
    }
}
