package vn.edu.hcmute.springboot3_4_12.exception;

public class StorageFileNotFoundException extends StorageException {
    private static final long serialVersionUID = 1L;
    public StorageFileNotFoundException(String message) {
        super(message);
    }
}
