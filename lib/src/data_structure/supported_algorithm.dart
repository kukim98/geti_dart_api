class SupportedAlgorithm {
  String algorithmName;
  String taskType;
  num modelSize;
  String modelTemplateId;
  num gigaflops;
  String summary;
  bool supportsAutoHpo;

  SupportedAlgorithm({
    required this.algorithmName,
    required this.taskType,
    required this.modelSize,
    required this.modelTemplateId,
    required this.gigaflops,
    required this.summary,
    required this.supportsAutoHpo
  });

  factory SupportedAlgorithm.fromJson({required Map<String, dynamic> json}) {
    return SupportedAlgorithm(
      algorithmName: json['algorithm_name'],
      taskType: json['task_type'],
      modelSize: json['model_size'],
      modelTemplateId: json['model_template_id'],
      gigaflops: json['gigaflops'],
      summary: json['summary'],
      supportsAutoHpo: json['supports_auto_hpo']
    );
  }
}