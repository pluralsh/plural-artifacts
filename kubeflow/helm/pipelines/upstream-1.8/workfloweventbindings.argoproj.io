apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  labels:
    application-crd-id: kubeflow-pipelines
  name: workfloweventbindings.argoproj.io
spec:
  group: argoproj.io
  names:
    kind: WorkflowEventBinding
    listKind: WorkflowEventBindingList
    plural: workfloweventbindings
    shortNames:
      - wfeb
    singular: workfloweventbinding
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
