%Doctor.Config{
  ignore_modules: [
    # Macro modules - internal DSL implementation
    Taapi.Indicator,
    Taapi.Delegator
  ],
  min_module_doc_coverage: 100,
  min_overall_doc_coverage: 80,
  min_overall_spec_coverage: 80
}
