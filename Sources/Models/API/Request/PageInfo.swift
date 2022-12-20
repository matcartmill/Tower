public struct PageInfo: Codable {
    public var page: Int
    public var per: Int
    
    public init(page: Int, per: Int) {
        self.page = page
        self.per = per
    }
}
