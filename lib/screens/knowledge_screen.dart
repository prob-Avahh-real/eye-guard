import 'package:flutter/material.dart';

/// 护眼知识库
class KnowledgeScreen extends StatelessWidget {
  const KnowledgeScreen({super.key});

  static const _articles = [
    {
      'title': '什么是数字眼疲劳？',
      'icon': '💻',
      'body': '''数字眼疲劳（Digital Eye Strain），也被称为计算机视觉综合征（CVS），
是由于长时间使用电脑、手机、平板等数字设备引起的眼部不适。

常见症状包括：
• 眼睛干涩、发红
• 视力模糊
• 头痛
• 颈部和肩部疼痛
• 对光敏感

长时间盯着屏幕会导致：
• 眨眼频率降低（正常约 15-20 次/分钟，看屏幕时可能降到 5-7 次）
• 眼部肌肉持续紧张
• 泪液蒸发加快

解决方案：遵循 20-20-20 法则，保持正确坐姿，定期做眼部运动。''',
    },
    {
      'title': '干眼症 — 原因与预防',
      'icon': '💧',
      'body': '''干眼症是最常见的眼科疾病之一，尤其在电子设备使用者中高发。

主要原因：
• 泪液蒸发过快（长时间睁眼、空调环境）
• 泪液分泌不足（年龄、药物影响）
• 睑板腺功能障碍（MGD）

电子产品使用者的特殊风险：
• 屏幕使用使眨眼频率降低 60%+
• 蓝光影响泪膜稳定性
• 空调和暖气加速泪液蒸发

预防措施：
• 有意识地增加眨眼频率（完整眨眼）
• 使用人工泪液（不含防腐剂）
• 保持环境湿度 40-60%
• 每 20 分钟让眼睛休息
• 热敷眼睑（40-45°C，10 分钟）
• 补充 Omega-3 脂肪酸''',
    },
    {
      'title': '结膜炎预防指南',
      'icon': '👁️',
      'body': '''结膜炎（俗称"红眼病"）是结膜组织的炎症，可分为感染性和非感染性。

电子产品使用者的注意事项：
• 长时间使用电子设备会降低免疫力
• 揉眼习惯增加感染风险
• 隐形眼镜佩戴者风险更高

预防要点：
• 勤洗手，避免用不洁的手揉眼
• 定期清洁手机、键盘等接触面
• 隐形眼镜佩戴不超过 8 小时
• 不与他人共用毛巾、眼药水
• 出现红眼、分泌物增多及时就医

过敏性结膜炎：
• 保持室内清洁，减少尘螨
• 花粉季节减少开窗
• 可使用抗过敏眼药水（遵医嘱）''',
    },
    {
      'title': '最佳屏幕设置',
      'icon': '🖥️',
      'body': '''正确的屏幕设置可以显著减少眼睛疲劳。

屏幕位置：
• 屏幕顶部与视线平齐或略低
• 距离眼睛约一臂长（50-70cm）
• 屏幕略微向后倾斜 10-20°

亮度和对比度：
• 屏幕亮度应与环境光一致（不刺眼也不过暗）
• 白色背景上黑色文字对比度最佳
• 避免在黑暗环境中使用高亮度屏幕

色温设置：
• 白天使用 6500K（标准色温）
• 晚间切换至暖色调（3400K 以下），减少蓝光
• 开启设备的「夜间模式」或「护眼模式」

环境光：
• 避免屏幕反光（调整角度或使用防眩膜）
• 环境照度建议 300-500 lux
• 屏幕不应是房间最亮的光源''',
    },
    {
      'title': '护眼营养素指南',
      'icon': '🥕',
      'body': '''饮食对眼睛健康至关重要。以下是对眼睛有益的关键营养素：

叶黄素和玉米黄质
• 来源：菠菜、羽衣甘蓝、蛋黄、玉米
• 作用：过滤蓝光，保护视网膜
• 建议摄入：每天 10mg 叶黄素 + 2mg 玉米黄质

Omega-3 脂肪酸（DHA/EPA）
• 来源：深海鱼（三文鱼、鲭鱼）、亚麻籽、核桃
• 作用：抗炎，改善干眼症状
• 建议摄入：每周 2-3 次鱼类

维生素 A
• 来源：胡萝卜、红薯、南瓜、动物肝脏
• 作用：维持正常视觉功能，预防夜盲
• 注意：过量有害，从食物摄取即可

维生素 C
• 来源：柑橘类、猕猴桃、彩椒、西兰花
• 作用：抗氧化，降低白内障风险

维生素 E
• 来源：坚果、种子、植物油
• 作用：保护眼细胞免受氧化损伤

锌
• 来源：牡蛎、牛肉、南瓜籽
• 作用：帮助维生素 A 输送至视网膜

每天一杯绿茶也很有帮助（茶多酚抗氧化）''',
    },
    {
      'title': '蓝光 — 事实与误区',
      'icon': '🔵',
      'body': '''关于蓝光的科学事实：

什么是蓝光？
• 波长 380-500nm 的可见光
• 自然来源：太阳光是最大的蓝光来源
• 人造来源：LED 屏幕、节能灯

蓝光的影响：
✅ 白天适度的蓝光对健康有益（调节生物钟、提升注意力）
❌ 夜间蓝光暴露会抑制褪黑素分泌，影响睡眠
⚠️ 长期高强度蓝光暴露可能增加黄斑变性风险（证据尚不充分）

常见误区：
• "防蓝光眼镜可以完全防止视疲劳" — 视疲劳主要来自用眼习惯，而非蓝光本身
• "蓝光会导致失明" — 日常使用的屏幕蓝光强度远低于有害阈值
• "所有蓝光都有害" — 白天适度蓝光对调节昼夜节律很重要

实用建议：
• 睡前 1-2 小时减少屏幕使用
• 开启设备的夜间模式
• 不要盲目购买昂贵的"防蓝光"产品
• 优先改善用眼习惯而非依赖护眼产品''',
    },
    {
      'title': '正确的眼部热敷方法',
      'icon': '🔥',
      'body': '''眼部热敷是缓解干眼症和视疲劳的有效方法。

准备工作：
• 温度：40-45°C（手感温热不烫）
• 工具选择：热毛巾、蒸汽眼罩、电热眼罩
• 时长：10-15 分钟

标准操作步骤：
1. 洗手，摘掉隐形眼镜
2. 准备温热毛巾（拧至不滴水）
3. 闭眼，将毛巾敷在眼睑上
4. 保持 10-15 分钟，毛巾凉了可重新加温
5. 取下毛巾后，用干净手指轻柔按摩眼睑边缘
6. 最后眨几次眼，感受泪液均匀分布

频率建议：
• 每日 1-2 次
• 晨起和睡前效果最佳
• 睑板腺功能障碍者可持续 2 周以上

注意事项：
• 感染性结膜炎期间禁止热敷
• 眼部手术后遵医嘱
• 温度不宜过高以免烫伤
• 使用一次性或专用毛巾，保持卫生''',
    },
    {
      'title': '儿童青少年护眼特别指南',
      'icon': '👶',
      'body': '''儿童青少年是近视高发群体，护眼尤为重要。

户外活动 — 最重要！
• 每天至少 2 小时户外活动
• 自然光有助于眼球正常发育
• 阳光促进多巴胺分泌，抑制眼轴增长

屏幕时间管控：
• 0-2 岁：不建议接触屏幕
• 2-5 岁：每天不超过 1 小时
• 6-18 岁：连续使用不超过 30 分钟

正确读写姿势：
• "一尺一寸一拳"
• 眼离书本一尺（33cm）
• 胸离桌沿一拳
• 手指离笔尖一寸（3cm）

定期检查：
• 每半年至一年检查视力
• 建立屈光发育档案
• 发现异常及时干预（如角膜塑形镜、低浓度阿托品）

充足睡眠：
• 学龄前儿童：10-13 小时
• 小学生：9-11 小时
• 青少年：8-10 小时''',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('护眼知识'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.only(top: 8, bottom: 24),
        itemCount: _articles.length,
        itemBuilder: (context, index) {
          final article = _articles[index];
          return _ArticleCard(
            title: article['title']!,
            icon: article['icon']!,
            body: article['body']!,
          );
        },
      ),
    );
  }
}

class _ArticleCard extends StatefulWidget {
  final String title;
  final String icon;
  final String body;

  const _ArticleCard({
    required this.title,
    required this.icon,
    required this.body,
  });

  @override
  State<_ArticleCard> createState() => _ArticleCardState();
}

class _ArticleCardState extends State<_ArticleCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        onTap: () => setState(() => _expanded = !_expanded),
        borderRadius: BorderRadius.circular(14),
        child: AnimatedCrossFade(
          firstChild: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text(widget.icon, style: const TextStyle(fontSize: 28)),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(widget.title,
                      style: theme.textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.w600)),
                ),
                Icon(
                  _expanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: theme.colorScheme.onSurface.withAlpha(120),
                ),
              ],
            ),
          ),
          secondChild: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(widget.icon, style: const TextStyle(fontSize: 28)),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(widget.title,
                          style: theme.textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.w600)),
                    ),
                    Icon(
                      Icons.keyboard_arrow_up,
                      color: theme.colorScheme.onSurface.withAlpha(120),
                    ),
                  ],
                ),
                const Divider(height: 20),
                Text(
                  widget.body,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
          crossFadeState: _expanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 250),
        ),
      ),
    );
  }
}
