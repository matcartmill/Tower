import Photos

public struct Photos: PermissionType { }

private extension PermissionState {
    init(from status: PHAuthorizationStatus) {
        switch status {
        case .notDetermined: self = .unknown
        case .authorized, .limited: self = .authorized
        case .denied, .restricted: self = .denied
        @unknown default: self = .denied
        }
    }
}

extension AnyPermission {
    public static var photos: Permission<Photos> {
        return .init(
            name: "Photos",
            status: { PermissionState(from: PHPhotoLibrary.authorizationStatus()) },
            requestAccess: { complete in
                PHPhotoLibrary.requestAuthorization { _ in
                    DispatchQueue.main.async {
                        complete(AnyPermission.photos.status())
                    }
                }
            })
    }
}
