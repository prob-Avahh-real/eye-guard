/// 眼部运动模型
class Exercise {
  final String id;
  final String name;
  final String description;
  final String icon; // emoji or icon data
  final int durationSeconds;
  final String category; // 'relax', 'focus', 'blink', 'circulation'
  final List<ExerciseStep> steps;

  const Exercise({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.durationSeconds,
    required this.category,
    required this.steps,
  });

  static List<Exercise> all = [
    // ── 放松类 ──
    Exercise(
      id: 'palming',
      name: '掌敷热敷法',
      description: '用手掌温热眼部，促进血液循环，缓解视疲劳',
      icon: '🤲',
      durationSeconds: 60,
      category: 'relax',
      steps: [
        ExerciseStep('双手快速搓动 5 秒产生热量', 5),
        ExerciseStep('闭上双眼，将温热手掌轻轻覆盖在眼皮上', 2),
        ExerciseStep('保持放松，深呼吸', 50),
        ExerciseStep('缓慢移开双手，眨几次眼', 3),
      ],
    ),
    Exercise(
      id: '20-20-20',
      name: '20-20-20 法则',
      description: '每 20 分钟，看 20 英尺（6 米）外的物体 20 秒',
      icon: '👁️',
      durationSeconds: 20,
      category: 'relax',
      steps: [
        ExerciseStep('停止当前屏幕活动', 2),
        ExerciseStep('看向窗外或远处（至少 6 米外）的物体', 2),
        ExerciseStep('保持注视远处物体', 14),
        ExerciseStep('缓慢收回视线，眨几次眼', 2),
      ],
    ),
    // ── 聚焦类 ──
    Exercise(
      id: 'near-far',
      name: '远近调焦',
      description: '远近交替聚焦，锻炼睫状肌灵活性',
      icon: '🔭',
      durationSeconds: 40,
      category: 'focus',
      steps: [
        ExerciseStep('伸出拇指，置于眼前约 15cm 处', 2),
        ExerciseStep('盯住拇指 3 秒', 3),
        ExerciseStep('移开拇指，看向远处 3 秒', 3),
        ExerciseStep('重复远近交替 5 次', 30),
        ExerciseStep('闭眼放松', 2),
      ],
    ),
    Exercise(
      id: 'figure-8',
      name: '∞ 字形运动',
      description: '眼球画∞字，放松眼外肌',
      icon: '♾️',
      durationSeconds: 30,
      category: 'focus',
      steps: [
        ExerciseStep('想象眼前有一个巨大的横放 8 字', 2),
        ExerciseStep('缓慢用眼球从左上方开始追踪 8 字轨迹', 13),
        ExerciseStep('反方向再追踪一次', 13),
        ExerciseStep('闭眼放松', 2),
      ],
    ),
    // ── 眨眼类 ──
    Exercise(
      id: 'blink',
      name: '完整眨眼训练',
      description: '缓慢完整眨眼，湿润眼球，预防干眼症',
      icon: '😉',
      durationSeconds: 30,
      category: 'blink',
      steps: [
        ExerciseStep('缓慢闭上双眼（上下眼睑完全接触）', 3),
        ExerciseStep('保持闭合 2 秒', 2),
        ExerciseStep('缓慢睁开', 2),
        ExerciseStep('重复 10 次完整眨眼', 20),
        ExerciseStep('自然眨眼放松', 3),
      ],
    ),
    Exercise(
      id: 'rapid-blink',
      name: '快速眨眼',
      description: '快速轻眨，刺激泪液分泌',
      icon: '💧',
      durationSeconds: 20,
      category: 'blink',
      steps: [
        ExerciseStep('快速轻眨眼 10 次（约 1 秒 2 次）', 5),
        ExerciseStep('闭眼休息 5 秒', 5),
        ExerciseStep('再快速眨眼 10 次', 5),
        ExerciseStep('闭眼放松', 5),
      ],
    ),
    // ── 循环类 ──
    Exercise(
      id: 'eye-roll',
      name: '眼球转动',
      description: '顺时针和逆时针转动眼球，放松眼外肌',
      icon: '🔄',
      durationSeconds: 30,
      category: 'circulation',
      steps: [
        ExerciseStep('缓慢顺时针转动眼球（上→右→下→左）', 12),
        ExerciseStep('闭眼休息 3 秒', 3),
        ExerciseStep('缓慢逆时针转动眼球', 12),
        ExerciseStep('闭眼放松', 3),
      ],
    ),
    Exercise(
      id: 'diagonal',
      name: '对角线注视',
      description: '沿对角线方向移动视线，增强眼部肌肉',
      icon: '✖️',
      durationSeconds: 25,
      category: 'circulation',
      steps: [
        ExerciseStep('看左上角，保持 2 秒', 2),
        ExerciseStep('移到右下角，保持 2 秒', 2),
        ExerciseStep('看右上角，保持 2 秒', 2),
        ExerciseStep('移到左下角，保持 2 秒', 2),
        ExerciseStep('重复对角线移动 3 轮', 12),
        ExerciseStep('闭眼放松', 3),
      ],
    ),
  ];
}

class ExerciseStep {
  final String instruction;
  final int durationSeconds;

  const ExerciseStep(this.instruction, this.durationSeconds);
}
