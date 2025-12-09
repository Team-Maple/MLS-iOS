public enum DictionaryTabRegistry {
    private static weak var controller: DictionaryTabControllable?

    public static func register(controller: DictionaryTabControllable) {
        self.controller = controller
    }

    public static func changeTab(index: Int) {
        controller?.changeTab(index: index)
    }
}
