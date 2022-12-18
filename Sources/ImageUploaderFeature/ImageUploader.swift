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
        case imageSelected
    }
    
    public init() { }
    
    public var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
                
            case .imageSelected:
                return .none
            }
        }
    }
}
