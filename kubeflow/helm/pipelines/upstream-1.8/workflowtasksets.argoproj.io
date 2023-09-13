apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  labels:
    application-crd-id: kubeflow-pipelines
  name: workflowtasksets.argoproj.io
spec:
  group: argoproj.io
  names:
    kind: WorkflowTaskSet
    listKind: WorkflowTaskSetList
    plural: workflowtasksets
    shortNames:
      - wfts
    singular: workflowtaskset
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
            status:
              type: object
              x-kubernetes-map-type: atomic
              x-kubernetes-preserve-unknown-fields: true
          required:
            - metadata
            - spec
          type: object
      served: true
      storage: true
      subresources:
        status: {}
