import ComposableArchitecture
import Models
import PhotosUI
import SwiftUI

public struct ImageUploader: ReducerProtocol {
    public struct State: Equatable {
        @BindableState var photoItem: PhotosPickerItem?
        
        public init() { }
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<ImageUploader.State>)
        case setPhotoData(Data?)
    }
    
    public init() { }
    
    public var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding(\.$photoItem):
                guard let item = state.photoItem else { return .none }
                
                return .task {
                    let data = try await item.loadTransferable(type: Data.self)
                    return .setPhotoData(data)
                }
                
            case .binding:
                return .none
                
            case .setPhotoData:
                return .none
            }
        }
    }
}
