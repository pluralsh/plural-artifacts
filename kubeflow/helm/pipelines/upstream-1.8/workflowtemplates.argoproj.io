apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  labels:
    application-crd-id: kubeflow-pipelines
  name: workflowtemplates.argoproj.io
spec:
  group: argoproj.io
  names:
    kind: WorkflowTemplate
    listKind: WorkflowTemplateList
    plural: workflowtemplates
    shortNames:
      - wftmpl
    singular: workflowtemplate
  scope: Namespaced
  versions:
    - name: v1alpha1
      schema:
        openAPIV3Schema:
          properties:
            apiVersion:
              type: string
            kind:
              type: string
            metadata:
              type: object
            spec:
              type: object
              x-kubernetes-map-type: atomic
              x-kubernetes-preserve-unknown-fields: true
          required:
            - metadata
            - spec
          type: object
      served: true
      storage: true
