# HuiSha Project Pattern Guide

这份文档记录 HuiSha 项目中已经验证过的一套 SwiftUI 快速开发方案。以后做类似 App 时，可以把它当作参考手册：先搭骨架，再按页面、路由、弹窗、数据结构逐步接入。

## 1. 项目目录风格

当前项目的主要目录可以按职责理解：

```text
HuiSha/
  Assets.xcassets                         # App 内 UI 图片资源
  MirelleAuvrion.swift                    # 根路由与全局弹窗挂载
  VeyraPromptLattice.swift                # 全局弹窗/Loading/Toast 控制器
  HuiShaApp.swift                         # App 入口与全局持久化对象注入
  AuvrionChromatics.swift                 # 全局颜色与通用 Shape
  KytheraFocusDismissal.swift             # 点击空白处收起键盘
  reciprocalPageSynchor/
    verisynGuidechroco/                   # 登录、注册、协议、资料完善等认证页
    mutualHomecorevibe/                   # 首页、聊天、举报、主 Tab 容器
    authenFriendticorex/                  # 好友、添加好友、他人主页、记录页
    reciproMeverico/                      # 个人中心、充值、黑名单
    ywqhDialognakfjql/                    # 自定义弹窗视图
  heaehtunivercerion/
    gnilwrldpiirdena/                     # 数据结构与本地 Store
    purelinkinfinite/                     # 默认用户头像原始资源
  DataCore/
    DataFiles/                            # 后续数据文件占位
    DataStructures/                       # 后续数据结构占位
```

原则：

- 页面文件按业务域分文件夹，不把所有 View 堆在根目录。
- 根路由、弹窗控制、颜色、键盘收起这种全局能力放在 `HuiSha/` 顶层。
- 数据结构与本地数据 Store 放在独立数据目录，避免和 UI 页面互相缠绕。
- 图片资源优先使用用户提供的素材，UI 还原时尽量用图片布局，而不是重新画复杂装饰。

## 2. 命名风格

项目使用偏复杂、不直白的英文组合词命名，例如：

```swift
MirelleAuvrion
VeyraPromptLattice
VelmoraUserGlyph
QuorraxisPersistVault
```

命名策略：

- 类型名使用 2 个以上不常见词组合。
- 避免过于功能化的单词，如 `UserManager`、`AppRouter`、`ToastView`。
- UI 文字仍保持正常中文，不为了命名风格影响用户体验。
- 数据字段可以更抽象，但需要文档说明真实含义。

示例：

```swift
struct VelmoraUserGlyph: Identifiable, Codable, Equatable {
    let id: Int
    var auricMail: String      // 邮箱
    var cipherPass: String     // 密码
    var soulTrace: String     // 头像本地路径
    var nameSigil: String      // 昵称
}
```

## 3. 根路由方案

项目使用 `NavigationStack + enum` 管理页面跳转。根页面是 `MirelleAuvrion`。

核心结构：

```swift
@State private var path: [AuvrionPage] = []

NavigationStack(path: $path) {
    RootView(...)
        .navigationDestination(for: AuvrionPage.self) { page in
            pageView(page)
                .navigationBarBackButtonHidden(true)
        }
}
```

路由枚举：

```swift
private enum AuvrionPage: Hashable {
    case caldrisGate
    case huishaHome
    case qhorfWhisper(Int)
    case virelonFlag
    case selqarethCard(Int)
    case kcnaiAccord(Bool)
}
```

跳转方法：

```swift
private func push(_ next: AuvrionPage) -> () -> Void {
    { path.append(next) }
}

private func pop() -> () -> Void {
    {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
}
```

优点：

- 页面跳转集中在根路由，不让子页面知道全局结构。
- 子页面只暴露闭包，例如 `backAction`、`submitAction`、`whisperAction`。
- 支持带参数页面，如 `qhorfWhisper(Int)`、`kcnaiAccord(Bool)`。
- 使用系统默认 NavigationStack 动画，不额外做低质自定义动画。

建议：

- 所有页面都隐藏系统返回按钮：`.navigationBarBackButtonHidden(true)`。
- 自定义返回按钮由页面内部绘制，行为由根路由传入 `pop()`。
- 当同一个页面在不同入口下保存逻辑不同时，使用不同路由 case 或不同闭包区分。例如资料页从注册进入保存后去首页，从个人中心进入保存后返回上一页。

## 4. 全局弹窗方案

全局弹窗由 `VeyraPromptLattice` 管理，根页面通过 overlay 挂载：

```swift
@StateObject private var promptLattice = VeyraPromptLattice()

ZStack {
    NavigationStack(...)
    VeyraPromptCurtain(lattice: promptLattice)
}
.environmentObject(promptLattice)
```

弹窗类型使用 enum：

```swift
enum VeyraPromptVeil: Equatable {
    case loading(String)
    case text(String)
    case morePanel
    case accountPanel
    case eulaPanel
}
```

已支持的能力：

- Loading：`showLoading`
- Loading 后执行动作：`showLoadingThen`
- Loading 后显示成功文字，再执行动作：`showLoadingThenTextThen`
- 文字提示：`showText`
- 聊天/他人页 more 弹窗：`showMorePanel(reportAction:)`
- 个人中心 more 弹窗：`showAccountPanel`
- 底部 EULA 弹窗：`showEulaPanel(cancelAction:agreeAction:)`

### Loading 后返回

用于登录、忘记密码、编辑资料等：

```swift
promptLattice.showLoadingThen("加载中", duration: 0.7) {
    submitAction()
}
```

登录页需要先从 `VelmoraUserGlyphStore.shared.glyphs` 中查找邮箱和密码都一致的用户。只有匹配成功后，才写入 `QuorraxisPersistVault` 中的当前用户 id、持久化进入首页标识和登录标识，再显示 loading 并跳转首页；匹配失败只显示文字提示，不触发 loading。

忘记密码页需要先校验三个输入框不为空、两次密码一致，再从用户表中查找邮箱。邮箱存在时调用 `reviseCipherPass(id:value:)` 更新密码，然后显示 loading 和 `密码修改成功` 提示，最后返回；邮箱不存在时只显示文字提示。

### Loading 后提示成功再返回

用于举报提交：

```swift
promptLattice.showLoadingThenTextThen(
    "提交中",
    successText: "举报信息提交成功",
    loadingDuration: 1.0,
    textDuration: 1.0
) {
    submitAction(trimmedReason)
}
```

### 底部弹窗注意点

EULA 弹窗要求“点击同意后 loading 叠在当前弹窗上，loading 结束后再关闭所有弹窗”。不要通过切换 enum case 来实现，否则 SwiftUI 会先执行旧弹窗退场动画再进入新弹窗，看起来像闪了一次。

正确做法：

- 保持 `veil = .eulaPanel` 不变。
- 在 `VeyraPromptLattice` 内维护 `eulaIsLoading`。
- 弹窗内部通过 `if lattice.eulaIsLoading { loadingCard(...) }` 叠 loading。
- 初始页判断 EULA 是否同意时使用全局持久化变量 `QuorraxisPersistVault.vellumAsterion`，不要再使用页面本地临时变量。

## 5. 页面交互风格

### 子页面只收闭包

例如聊天页：

```swift
struct bcawuifbiw_oqfbabcak: View {
    var backAction: () -> Void = {}
    var reportAction: () -> Void = {}
    var profileAction: () -> Void = {}
}
```

页面内部不直接操作 `NavigationPath`，只调用闭包。

### 输入校验

表单页先校验，再 loading，再跳转：

```swift
guard !email.isEmpty, !password.isEmpty else {
    promptLattice.showText("请完整填写信息")
    return
}

promptLattice.showLoadingThen {
    submitAction()
}
```

如果用户明确不需要邮箱格式、密码长度限制，就只做空值和一致性判断。

注册页的顺序：

- 先判断昵称、邮箱、密码、确认密码是否为空。
- 再从 `VelmoraUserGlyphStore.shared.glyphs` 中查邮箱是否已存在，存在时提示不要重复注册。
- 邮箱不存在时再判断两次密码是否一致。
- 一致后通过 loading 进入资料页，并传递 `SelqarethRegisterDraft(auricName:auricMail:auricCipher:)`，避免注册草稿字段使用过于功能化的 `nickname/email/password`。
- 资料页填写完成后，使用注册草稿加资料页字段调用 `addGlyph(...)` 创建用户，loading 结束后再写入当前用户 id、持久化首页标识和登录状态。

根路由 `MirelleAuvrion` 会直接读取持久化首页标识 `QuorraxisPersistVault.nyraxisCalvethor`。为 `true` 时，`NavigationStack` 的根页面就是首页；为 `false` 时，根页面是初始页 `NoveraQuinthalis`。因此进入首页时不要再额外 `push(.home)`，而是在 loading 结束后设置持久化首页标识并清空 `path`，让根页面自己切换。

游客登录入口放在根路由中处理。点击游客登录时，loading 结束后检查用户表最后一个用户的邮箱是否为 `cv2u9b1b73bao`：如果是，则直接把当前用户 id 设置为最后一个用户；如果不是，则新增一个邮箱为 `cv2u9b1b73bao` 的游客用户，昵称为 `user + (用户表长度 - 5)`，再把当前用户 id 设置为新增用户。随后设置持久化进入首页标识为 `true`，清空 `path` 进入首页。

个人中心账号弹窗 `fbryqiw_nsoqlcu` 的按钮动作由根路由传入。退出登录需要先把弹窗切成 loading，loading 结束后再把持久化进入首页标识和登录标识都改为 `false`，并清空 `NavigationStack` 回到初始页；删除账号需要在 loading 结束后先把当前用户的邮箱和密码改为空字符串，再执行同样的退出流程。回到初始页后短暂延时，再把当前用户 id 恢复为默认值 `271968103`。

好友页 `yyqfohais_ioofbasn` 使用当前用户的 `kinraMarks` 作为数据源，并用当前用户的 `shadeMarks` 过滤黑名单用户。渲染时根据好友 id 到 `VelmoraUserGlyphStore.shared.glyphs` 中取头像和昵称；点击好友头像/昵称时把真实好友 id 传给他人页路由。

添加好友页 `QorvaneLumisAdd` 使用用户表 `VelmoraUserGlyphStore.shared.glyphs` 作为数据源，并过滤当前用户自己、当前用户黑名单 `shadeMarks` 中的用户、以及已经存在于当前用户好友表 `kinraMarks` 中的用户。列表展示头像、昵称、性别年龄和 ID；搜索框按昵称或 ID 做本地过滤；点击头像/用户信息时把真实用户 id 传给他人页路由。

添加好友页点击 `加好友` 前需要检查登录标识 `QuorraxisPersistVault.sylvarnEphorix`。未登录时弹出 `ufblkdhi_vzkaywq` 去登录弹窗；已登录时才显示好友申请已发送提示并执行后续动作。

黑名单页 `MevericoNulistora` 使用当前用户的 `shadeMarks` 作为数据源，根据 id 从用户表中读取头像和昵称。右侧移除按钮直接把对应 id 从当前用户 `shadeMarks` 中删除，左侧头像不跳转。首页消息页、好友页、添加好友页、黑名单页在数据为空时显示占位图 `evoligntehozastinpece`，尺寸为 `138x166`。

他人页 `uoqnfbajse_qbvjvsnoen` 通过传入的用户 id 到用户表读取头像、昵称、性别、年龄和展示 ID；亲密度卡片中的双方头像分别来自当前用户和目标用户。消息统计从 `MirelithMessageGlyphStore` 中筛选双方参与的会话，盲盒消息数量通过聊天表 `QhorfRune.blindKind == true` 计算，相识天数用最早消息时间与当前日期计算。

他人页点击聊天按钮前需要读取登录标识 `QuorraxisPersistVault.sylvarnEphorix`。为 `false` 时通过 `VeyraPromptLattice.showLoginPanel(loginAction:)` 弹出 `ufblkdhi_vzkaywq`；为 `true` 时继续判断当前用户 `kinraMarks` 是否包含目标用户 id，不包含时提示 `互为好友才能聊天`，包含时才进入聊天页。弹窗第一个按钮只关闭弹窗，第二个按钮先 loading，再执行和退出登录一致的回初始页流程。

more 按钮点击前也需要检查登录标识 `QuorraxisPersistVault.sylvarnEphorix`。为 `false` 时弹出 `ufblkdhi_vzkaywq` 去登录弹窗；为 `true` 时才打开 more 弹窗。more 弹窗 `njaueiqb_zzneefja` 需要通过 `showMorePanel(targetId:reportAction:blockAction:deleteAction:)` 接收正在操作的目标用户 id。第一个按钮关闭弹窗并进入举报页；第二个按钮先 loading，再把目标用户 id 加入当前用户 `shadeMarks`，随后清空 `path` 回到首页根页面；第三个按钮先 loading，再从当前用户 `kinraMarks` 中移除目标用户 id，同样回到首页根页面。这里回首页是利用持久化首页标识为 `true` 的根页面切换，不新增页面栈，也不是回初始页。

个人中心 `truemirsou_thmunity` 中间钻石入口进入支付页前也要检查登录标识 `QuorraxisPersistVault.sylvarnEphorix`。未登录时弹出 `ufblkdhi_vzkaywq` 去登录弹窗；已登录时才执行充值页跳转。

个人中心 `truemirsou_thmunity` 使用当前用户 id 从用户表读取并展示头像、昵称、性别年龄、ID 和钻石数量，避免继续使用静态 UI 文案。

从个人中心进入 `AuvrionSelqarethProfile` 时属于编辑资料模式：页面进入后先按当前用户 id 从用户表预填头像、昵称、地区、性别和年龄。点击底部按钮时先检查登录标识，未登录弹出 `ufblkdhi_vzkaywq`；已登录时校验表单不为空，更新当前用户资料和头像，再显示 loading 与 `修改成功` 文案，最后返回上一页。

个人信息页的年龄选择使用具体年龄数字，不使用年龄区间。当前选项为 `18...99`，保存时直接把选中的数字转成 `Int` 写入用户表。

### 防重复点击

提交类页面用本地状态锁：

```swift
@State private var isSubmitting = false

private func validateAndSubmit() {
    guard !isSubmitting else { return }
    ...
    isSubmitting = true
    promptLattice.showLoadingThenTextThen(...) {
        submitAction(...)
    }
}
```

按钮上也加：

```swift
.disabled(isSubmitting)
```

### 点击输入框外失焦

统一 View 扩展：

```swift
extension View {
    func dismissKeyboardOnOutsideTap() -> some View {
        contentShape(Rectangle())
            .onTapGesture {
                UIApplication.shared.sendAction(
                    #selector(UIResponder.resignFirstResponder),
                    to: nil,
                    from: nil,
                    for: nil
                )
            }
    }
}
```

使用：

```swift
.dismissKeyboardOnOutsideTap()
```

## 6. 视觉还原方案

项目主要是从设计图还原 SwiftUI 页面。优先策略：

- 用户已提供图片时，优先使用图片资源，而不是自己重画。
- 背景大图使用 `.resizable()` 铺满。
- 图标按钮使用图片 asset，保证和设计图一致。
- 页面中大块白色/灰色区域用 Shape 或背景色组合。
- 顶部圆角大背景使用通用 Shape `TopRoundVeylora`。
- 卡片、按钮圆角尽量贴近设计图，不盲目使用大圆角。

适合抽象的 UI 元素：

- 全局颜色：`AuvrionChromatics`
- 顶部圆角 Shape：`TopRoundVeylora`
- 表单 shell：`QuenraLuminethShell`
- 表单行：`VellumQuorraxisStack`
- 全局弹窗：`VeyraPromptLattice`

不建议抽象的内容：

- 每个页面的装饰性图片布局。
- 只出现一次的复杂卡片。
- 设计图中位置很特殊的 UI 组合。

## 7. 全局持久化变量方案

项目采用 `ObservableObject + @AppStorage + environmentObject`。

入口：

```swift
final class QuorraxisPersistVault: ObservableObject {
    static let single = QuorraxisPersistVault()
    private init() {}

    @AppStorage("quorraxis.auvrionSelqareth") var auvrionSelqareth: Int = 0
    @AppStorage("quorraxis.nyraxisCalvethor") var nyraxisCalvethor: String = ""
}
```

App 注入：

```swift
@main
struct HuiShaApp: App {
    @StateObject private var persistVault = QuorraxisPersistVault.single

    var body: some Scene {
        WindowGroup {
            MirelleAuvrion()
                .environmentObject(persistVault)
        }
    }
}
```

使用：

```swift
@EnvironmentObject private var persistVault: QuorraxisPersistVault
```

为什么这样做：

- `@AppStorage` 负责持久化。
- `ObservableObject` 方便全局注入。
- 页面变化时更容易触发 SwiftUI 更新。
- 比静态 `UserDefaults` 更适合 SwiftUI 页面状态。

## 8. 本地 JSON 数据结构方案

用户数据使用 `Codable + ObservableObject Store + Documents JSON`。

数据结构：

```swift
struct VelmoraUserGlyph: Identifiable, Codable, Equatable {
    let id: Int
    var auricMail: String
    var cipherPass: String
    var soulTrace: String
    var nameSigil: String
    var dianthCount: Int
    var shadeMarks: [Int]
    var kinraMarks: [Int]
    var realmMark: String
    var mienKind: String
    var yearCount: Int
    var veyraResidue: Int
}
```

Store：

```swift
final class VelmoraUserGlyphStore: ObservableObject {
    static let shared = VelmoraUserGlyphStore()
    @Published private(set) var glyphs: [VelmoraUserGlyph] = []
}
```

持久化文件：

```text
Documents/velmoraUserGlyphs.json
```

Store 需要包含：

- 初始化时读取本地 JSON。
- 如果 JSON 不存在，写入默认数据。
- 修改数据后自动保存。
- 新增用户时自动分配下一个 id。
- 除 id 外，每个字段都提供修改方法。

示例：

```swift
func addGlyph(...)
func reviseAuricMail(id: Int, value: String)
func reviseCipherPass(id: Int, value: String)
func reviseSoulTrace(id: Int, value: String)
func reviseSoulTrace(id: Int, avatarData: Data)
func reviseNameSigil(id: Int, value: String)
func reviseDianthCount(id: Int, value: Int)
func reviseShadeMarks(id: Int, value: [Int])
func reviseKinraMarks(id: Int, value: [Int])
func reviseRealmMark(id: Int, value: String)
func reviseMienKind(id: Int, value: String)
func reviseYearCount(id: Int, value: Int)
func reviseVeyraResidue(id: Int, value: Int)
func shiftVeyraResidue(id: Int, amount: Int)
```

本项目不需要兼容已安装旧版本或旧沙盒 JSON；每次下载后都以项目内 seeds 作为基础数据。持久化 JSON 只按当前 Swift 字段名读写，避免保留旧 key 映射造成命名回潮。新增字段时如需默认值，可用当前字段名的 `decodeIfPresent` 兜底。

用户 ID 展示规则：

- 数据和路由逻辑仍然使用 `VelmoraUserGlyph.id` 的真实 Int 值。
- 页面上展示用户 ID 时必须使用 `velmoraDisplayUserId(_:)`，通过真实 id 派生稳定数字前缀，让展示 ID 更像完整账号。
- 派生前缀只用于展示，不写回数据；同一个真实 id 每次登录看到的展示 ID 必须一致。

## 8.1 支付页 StoreKit 1 内购方案

支付页 `VelorDintRcare` 使用 StoreKit 1 完成消耗型内购，不能只做静态点击：

- StoreKit 逻辑集中放在 `VelorAsterBridge`，负责 `SKProductsRequest`、`SKPaymentQueue` 监听、购买成功/失败回调和 `finishTransaction`。
- 支付页进入时先显示 `支付初始化中` loading，再调用 `wakeDianthIfNeeded()` 请求商品信息；商品请求成功或失败都必须结束 loading。
- 页面价格固定展示 `VelorDianthRune.fallbackPrice` 格式化后的美元价格，不使用 StoreKit 本地化货币符号覆盖页面价格。
- `VelorDianthRune.fallbackPrice` 必须是 `Double` 类型，只保存数值；美元 `$` 符号只在页面展示/格式化价格时拼接。
- 点击充值档位时调用 `VelorAsterBridge.cast(_:)` 发起购买；购买中同一时间只允许一个商品处于支付状态。
- 支付开始后必须显示全局大 loading `支付中`，直到交易成功、失败、取消或其它支付终态后结束；商品卡片上的局部 loading 也保留。
- 购买成功后调用 `VelmoraUserGlyphStore.shiftDianthCount(id:amount:)` 给当前登录用户增加对应钻石，并提示 `充值成功`。
- 购买失败、用户取消、商品未加载、设备禁用内购等情况需要给出轻提示，不直接改用户金币。
- 消耗型商品不做恢复发放；收到 `.restored` 交易时只结束交易。
- 商品档位和商品 ID 必须集中维护在 `DianthAsterVault.runes`。

当前商品 ID 使用项目内短标识，集中写在 `DianthAsterVault.runes`：

```swift
lvbsvhxcgcrvesor
dybuplhbtntkqaul
dxismgcwewhrtezo
khtxlcejaxmqcsra
yadwwvxspgxwlndb
qnrcuelbtiuflyky
ymohxnvpkqxutvab
```

## 9. 用户头像存储方案

头像字段不要存 Asset 名字。用户从相册选择图片后，Asset 名字无法表达真实用户文件。

推荐方案：

- 数据结构里头像字段仍为 `String`。
- 这个 String 表示 Documents 中的本地文件路径。
- 默认头像从 bundle 的 `purelinkinfinite` 文件夹复制到 Documents。
- 用户相册图片保存为 Data 到 Documents，再存路径。

默认头像：

```swift
soulTrace: velmoraCacheAvatarSeed("suarrunexseternimeon1.jpg")
```

用户上传头像：

```swift
func reviseSoulTrace(id: Int, avatarData: Data) {
    guard let path = velmoraStoreAvatarData(avatarData, userId: id) else { return }
    reviseSoulTrace(id: id, value: path)
}
```

保存目录：

```text
Documents/purelinkinfinite/
```

显示头像：

```swift
if let uiImage = UIImage(contentsOfFile: user.soulTrace) {
    Image(uiImage: uiImage)
        .resizable()
        .scaledToFill()
}
```

好处：

- 默认头像和用户上传头像走同一套显示方式。
- JSON 中只存路径，结构简单。
- 用户换头像时只更新路径即可。
- 资源文件和用户数据文件分离。

## 9.1 消息数据结构方案

聊天消息使用独立数据结构，和用户表分开保存：

```swift
struct MirelithMessageGlyph: Identifiable, Codable, Equatable {
    let id: Int
    var mirelMarks: [Int]  // 两个聊天用户 id
    var murmurSigil: String    // 页面显示文字
    var timeSigil: Date          // 本地时间
}
```

Store 使用 `MirelithMessageGlyphStore`，保存到：

```text
Documents/mirelithMessageGlyphs.json
```

新增消息时外部传文字，时间使用本地当前时间：

```swift
func addGlyph(mirelMarks: [Int], murmurSigil: String) -> Int
```

修改方法只允许改显示文字和时间：

```swift
func reviseMurmurSigil(id: Int, value: String)
func reviseTimeSigil(id: Int)
```

原则：

- `mirelMarks` 保持 `[Int]`，用于记录双方用户 id。
- 文案由外部传入，便于聊天页、盲盒消息、快捷回复共用。
- 时间不由外部传入，统一使用 `Date()`，避免页面层伪造或格式不一致。
- `addGlyph` 返回新增会话 id，聊天页在没有现成会话时可立即用这个 id 新增第一条聊天内容。

首页消息列表使用消息表和用户表组合展示。基本流程：

1. 从 `QuorraxisPersistVault` 读取当前用户 id。
2. 从 `VelmoraUserGlyphStore` 找到当前用户。
3. 只展示 `mirelMarks` 中包含当前用户 id 的消息。
4. 使用当前用户的 `shadeMarks` 过滤消息。
5. 消息的 `mirelMarks` 中任意用户在黑名单里时，这条消息不显示。
6. 展示时必须显示 `mirelMarks` 中不是当前用户的那个用户，读取头像、昵称和消息文字。

过滤示例：

```swift
let shadeMarks = Set(auvrionPulse?.shadeMarks ?? [])

let murmurThreads = messageStore.glyphs.filter { threadGlyph in
    threadGlyph.mirelMarks.contains(selfMark)
        && shadeMarks.isDisjoint(with: Set(threadGlyph.mirelMarks))
}
```

如果当前用户暂时不存在，黑名单按空数组处理，避免首页数据意外为空。

## 9.2 聊天内容数据结构方案

聊天内容和消息会话分开保存。消息结构负责会话级数据，聊天结构负责每一条聊天内容：

```swift
struct QhorfRune: Identifiable, Codable, Equatable {
    let id: Int
    var mirelMark: Int     // 所属消息 id
    var quillMark: Int      // 书写者 id
    var textSigil: String    // 文字内容
    var soulTrace: String   // 图片内容，本地路径或资源标识
    var audioSigil: String   // 音频内容，本地路径或资源标识
    var audioSpan: Int    // 音频时长，秒
    var blindKind: Bool       // 是否为盲盒消息，true 是，false 否
}
```

Store 使用 `QhorfRuneStore`，保存到：

```text
Documents/qhorfRuneGlyphs.json
```

只提供新增方法：

```swift
func addGlyph(
    mirelMark: Int,
    quillMark: Int,
    textSigil: String = "",
    soulTrace: String = "",
    audioSigil: String = "",
    audioSpan: Int = 0,
    blindKind: Bool = true
)
```

原则：

- `mirelMark` 关联消息会话。
- `quillMark` 关联用户表。
- `blindKind` 只用于判断是否为盲盒消息，`true` 表示盲盒消息，`false` 表示普通消息。
- 图片和音频字段保持 String，方便后续统一使用 Documents 本地路径。
- `audioSpan` 使用 Int 秒数，保存和展示都简单。
- 当前只允许新增，不提供修改方法，避免聊天记录被随意改写。
- 数据层 Swift 命名使用 `mirel/qhorf/velmora/dianth/veyra` 词根；JSON 持久化同样使用当前 Swift 字段名，不保留旧字段映射。

## 9.3 聊天页交互规则

聊天页 `bcawuifbiw_oqfbabcak` 使用项目 seeds 与本地 Store 数据：

- 路由进入聊天页时必须携带目标用户 id，标题、头像、亲密度卡片头像都从用户表读取。
- 聊天内容从 `MirelithMessageGlyphStore` 找到双方会话，再用 `QhorfRuneStore` 根据 `mirelMark` 读取每条内容。
- 会话不存在时，发送第一条消息前先调用 `MirelithMessageGlyphStore.addGlyph` 创建会话，再写聊天内容。
- 文本消息写入 `textSigil`；图片消息写入 `soulTrace`，本地保存到 `Documents/qhorfRuneImages/`。

底部词组面板规则：

- 默认展示词组面板，词组来自全局变量 `celuiatnryrgever`，每次显示 3 条。
- 点击词组直接发送，必须写入 `blindKind: true`，并把会话摘要更新为 `「盲盒消息」+ 词组内容`。
- 聊天气泡旁的 `「盲盒消息」` 标签按发送者决定位置：对方发送时显示在气泡后面，当前用户发送时显示在气泡前面。
- 词组框尺寸为 `281x256`，刷新按钮尺寸为 `281x56`。
- 有免费刷新次数时，刷新按钮用 `purevibrancywave.png`；没有免费次数时用 `innercirclesphere.png`。
- 免费次数文案在聊天页刷新按钮右上角渲染，读取当前用户 `veyraResidue`。
- 刷新逻辑必须先判断 `veyraResidue`，足够则扣 1 次并刷新 3 条词组；不足时再判断 `dianthCount >= 100`，足够则扣 100 金币并刷新；金币也不足时弹出 `tbiomvy_qwubcsafw`。
- 刷新按钮需要短点击锁，避免连续点击导致免费次数显示或扣减异常。

手写回复面板规则：

- 点击词组框右上角 `手写回复>` 按钮切换到手写回复面板。
- 手写回复面板白色背景必须贴屏幕左右边缘和底部，不继承词组面板的左右缩进。
- `oulscillaoarcteredli.png` 是返回词组面板按钮。
- `spritimeionruefntionl.png` 是相册图片按钮，使用 `PhotosPicker` 打开相册；选中后保存图片并发送图片消息。
- `inwsmevernemment.png` 是小麦克风按钮，点击后直接显示/隐藏 `crbillancelpueononli.png`，不做动画效果。
- `crbillancelpueononli.png` 尺寸为 `232x43`，显示在输入栏下方居中；点击时提示 `长按开始录音`。
- 长按 `crbillancelpueononli.png` 开始录音，松开结束录音并发送语音消息；录音文件保存到 `Documents/qhorfRuneAudios/`。
- 开始录音时在 `crbillancelpueononli.png` 上方显示 `treelreflectiulhaofv.png`，表示录音中。
- 录音结束后写入 `audioSigil` 和 `audioSpan`，会话摘要更新为 `[语音]`，并隐藏下方语音录制图片。
- 录音消息气泡沿用普通聊天气泡背景样式，不单独使用图片背景；气泡内显示波形图标和秒数，点击录音气泡时播放本地录音文件。
- 手写文本输入框占据剩余宽度，点击发送写入普通文本消息，`blindKind: false`。

## 10. Web 协议页面方案

协议页 `KcnaiwfoTqnsoa` 接收一个 Bool 参数：

- `true`：用户协议
- `false`：隐私政策

页面内用 `WKWebView` 展示网页，加载前在网页背后放大号黑色“正在加载”。网页背景保持白色。

原则：

- 协议页面仍使用自定义返回按钮。
- 不使用系统导航栏。
- WebView 区域按设计图留出顶部空白和灰/白内容区域。

## 11. 推荐开发流程

以后做类似项目，可以按这个顺序推进：

1. 建立目录结构和资产目录。
2. 创建全局颜色、Shape、键盘失焦工具。
3. 建 `MirelleAuvrion` 根路由。
4. 建 `VeyraPromptLattice` 全局弹窗控制器。
5. 先做静态页面还原，优先使用图片资源。
6. 页面静态完成后，再给每个页面加闭包入口。
7. 在根路由统一接跳转。
8. 给表单加输入、校验、loading、成功提示。
9. 加 `@AppStorage` 全局持久化对象。
10. 加本地 JSON Store 与数据结构。
11. 把页面接入项目 seeds 与本地 Store。
12. 每完成一组功能跑一次构建。

## 12. 常见坑

### 1. 弹窗 case 切换导致动画闪烁

如果底部弹窗内部要出现 loading，不要从 `.eulaPanel` 切到 `.loading` 或另一个 `.eulaPanelLoading`，否则会触发退场和进场。应保留同一个 case，用内部状态控制 loading。

### 2. `ObservableObject` 报不完整

如果类声明 `ObservableObject` 后构建报：

```text
type does not conform to protocol ObservableObject
```

补：

```swift
import Combine
```

### 3. 提交按钮重复点击

所有网络/保存/举报/支付类按钮都要加 `isSubmitting` 或类似状态，点击后立即锁住。

### 4. 子页面不要直接操作根 path

子页面只收闭包，不接触 `NavigationPath`。这样页面更容易复用，也能处理同一页面不同入口的不同行为。

### 5. 用户头像不要存 Asset 名

真实用户头像来自相册，应保存为 Documents 文件路径。默认资源也复制到 Documents，统一显示逻辑。

### 6. 不要过早抽象 UI

这个项目的设计图大量依赖图片和特殊位置。只抽象确定会复用的东西：表单、弹窗、颜色、路由。单页特殊布局保留在页面里更稳。

## 13. 新项目可复制模板

最小骨架：

```swift
@main
struct NewApp: App {
    @StateObject private var persistVault = PersistVault.single

    var body: some Scene {
        WindowGroup {
            RootRouter()
                .environmentObject(persistVault)
        }
    }
}
```

```swift
struct RootRouter: View {
    @State private var path: [AppPage] = []
    @StateObject private var prompt = PromptLattice()

    var body: some View {
        ZStack {
            NavigationStack(path: $path) {
                StartPage(...)
                    .navigationDestination(for: AppPage.self) { page in
                        pageView(page)
                            .navigationBarBackButtonHidden(true)
                    }
            }

            PromptCurtain(lattice: prompt)
        }
        .environmentObject(prompt)
    }
}
```

```swift
enum AppPage: Hashable {
    case login
    case home
    case detail(Int)
}
```

这个模式适合需要快速还原多页面 UI、带本地数据、带登录/注册/协议/弹窗/个人中心的轻量 App。

## 用户 id 固定图规则

- 他人主页亲密度主图按目标用户 id 固定选择：`id == 1` 使用 `luousesecwoerlndspit1.png`，其他用户使用 `luousesecwoerlndspit0.png`。
- 聊天页亲密度主图按目标用户 id 固定选择：`id == 1` 使用 `poriplsflowoldnhizco1.png`，其他用户使用 `poriplsflowoldnhizco0.png`。
- 好友列表名字后的徽标按好友 id 固定选择：`id == 1` 使用 `earpuleetersencanton1.png`，其他用户使用 `earpuleetersencanton0.png`。

## 初始页入口规则

- 初始页的普通登录入口跳转登录页，游客登录入口必须直接调用 `enterAsGuest()`，不要把两个入口都接到 `.login`。
- 初始页按钮删除后，要同步删除 `NoveraQuinthalis` 的无用 action 参数和 `MirelleAuvrion` 的对应传参，避免保留不可达入口。

## 协议网页规则

- 协议页 `KcnaiwfoTqnsoa` 使用 `WKWebView` 时必须明确撑满剩余空间，并保留 loading/失败文案，避免线上地址慢或不可达时显示纯白页。

## 项目命名规则

- 路由 case、页面闭包、局部方法和内购类型命名要带项目词根，避免 `login/home/chat/recharge/flow` 这类通用词；单个 case 名称控制在 16 个字符以内。
- 不保留旧沙盒数据兼容字段；当前项目内 seeds 和当前 Swift 字段名就是唯一数据基准。
- 单页内部命名可以牺牲部分直白可读性换取项目主题感，但同一文件内不要重复复用同一组通用名称；例如添加好友页使用 `lumis/kinra/qorvane/selqareth` 词根组合。
- 为降低模板感，路由栈、弹窗 action、列表行、空状态、头像 helper、支付档位等小变量优先使用 `auric/veyra/kinra/qhorf/velor/dianth/mirelith` 等项目词根；`body`、`id`、`path(in:)` 等框架命名可以保留。
