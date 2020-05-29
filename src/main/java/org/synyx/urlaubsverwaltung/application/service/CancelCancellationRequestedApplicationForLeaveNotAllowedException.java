package org.synyx.urlaubsverwaltung.application.service;

public class CancelCancellationRequestedApplicationForLeaveNotAllowedException extends RuntimeException {
    CancelCancellationRequestedApplicationForLeaveNotAllowedException(String message) {
        super(message);
    }
}
