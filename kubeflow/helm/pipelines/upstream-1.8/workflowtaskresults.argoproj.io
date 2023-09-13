apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  labels:
    application-crd-id: kubeflow-pipelines
  name: workflowtaskresults.argoproj.io
spec:
  group: argoproj.io
  names:
    kind: WorkflowTaskResult
    listKind: WorkflowTaskResultList
    plural: workflowtaskresults
    singular: workflowtaskresult
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
            message:
              type: string
            metadata:
              type: object
            outputs:
              properties:
                artifacts:
                  items:
                    properties:
                      archive:
                        properties:
                          none:
                            type: object
                          tar:
                            properties:
                              compressionLevel:
                                format: int32
                                type: integer
                            type: object
                          zip:
                            type: object
                        type: object
                      archiveLogs:
                        type: boolean
                      artifactory:
                        properties:
                          passwordSecret:
                            properties:
                              key:
                                type: string
                              name:
                                type: string
                              optional:
                                type: boolean
                            required:
                              - key
                            type: object
                          url:
                            type: string
                          usernameSecret:
                            properties:
                              key:
                                type: string
                              name:
                                type: string
                              optional:
                                type: boolean
                            required:
                              - key
                            type: object
                        required:
                          - url
                        type: object
                      from:
                        type: string
                      fromExpression:
                        type: string
                      gcs:
                        properties:
                          bucket:
                            type: string
                          key:
                            type: string
                          serviceAccountKeySecret:
                            properties:
                              key:
                                type: string
                              name:
                                type: string
                              optional:
                                type: boolean
                            required:
                              - key
                            type: object
                        required:
                          - key
                        type: object
                      git:
                        properties:
                          depth:
                            format: int64
                            type: integer
                          disableSubmodules:
                            type: boolean
                          fetch:
                            items:
                              type: string
                            type: array
                          insecureIgnoreHostKey:
                            type: boolean
                          passwordSecret:
                            properties:
                              key:
                                type: string
                              name:
                                type: string
                              optional:
                                type: boolean
                            required:
                              - key
                            type: object
                          repo:
                            type: string
                          revision:
                            type: string
                          sshPrivateKeySecret:
                            properties:
                              key:
                                type: string
                              name:
                                type: string
                              optional:
                                type: boolean
                            required:
                              - key
                            type: object
                          usernameSecret:
                            properties:
                              key:
                                type: string
                              name:
                                type: string
                              optional:
                                type: boolean
                            required:
                              - key
                            type: object
                        required:
                          - repo
                        type: object
                      globalName:
                        type: string
                      hdfs:
                        properties:
                          addresses:
                            items:
                              type: string
                            type: array
                          force:
                            type: boolean
                          hdfsUser:
                            type: string
                          krbCCacheSecret:
                            properties:
                              key:
                                type: string
                              name:
                                type: string
                              optional:
                                type: boolean
                            required:
                              - key
                            type: object
                          krbConfigConfigMap:
                            properties:
                              key:
                                type: string
                              name:
                                type: string
                              optional:
                                type: boolean
                            required:
                              - key
                            type: object
                          krbKeytabSecret:
                            properties:
                              key:
                                type: string
                              name:
                                type: string
                              optional:
                                type: boolean
                            required:
                              - key
                            type: object
                          krbRealm:
                            type: string
                          krbServicePrincipalName:
                            type: string
                          krbUsername:
                            type: string
                          path:
                            type: string
                        required:
                          - path
                        type: object
                      http:
                        properties:
                          headers:
                            items:
                              properties:
                                name:
                                  type: string
                                value:
                                  type: string
                              required:
                                - name
                                - value
                              type: object
                            type: array
                          url:
                            type: string
                        required:
                          - url
                        type: object
                      mode:
                        format: int32
                        type: integer
                      name:
                        type: string
                      optional:
                        type: boolean
                      oss:
                        properties:
                          accessKeySecret:
                            properties:
                              key:
                                type: string
                              name:
                                type: string
                              optional:
                                type: boolean
                            required:
                              - key
                            type: object
                          bucket:
                            type: string
                          createBucketIfNotPresent:
                            type: boolean
                          endpoint:
                            type: string
                          key:
                            type: string
                          lifecycleRule:
                            properties:
                              markDeletionAfterDays:
                                format: int32
                                type: integer
                              markInfrequentAccessAfterDays:
                                format: int32
                                type: integer
                            type: object
                          secretKeySecret:
                            properties:
                              key:
                                type: string
                              name:
                                type: string
                              optional:
                                type: boolean
                            required:
                              - key
                            type: object
                          securityToken:
                            type: string
                        required:
                          - key
                        type: object
                      path:
                        type: string
                      raw:
                        properties:
                          data:
                            type: string
                        required:
                          - data
                        type: object
                      recurseMode:
                        type: boolean
                      s3:
                        properties:
                          accessKeySecret:
                            properties:
                              key:
                                type: string
                              name:
                                type: string
                              optional:
                                type: boolean
                            required:
                              - key
                            type: object
                          bucket:
                            type: string
                          createBucketIfNotPresent:
                            properties:
                              objectLocking:
                                type: boolean
                            type: object
                          encryptionOptions:
                            properties:
                              enableEncryption:
                                type: boolean
                              kmsEncryptionContext:
                                type: string
                              kmsKeyId:
                                type: string
                              serverSideCustomerKeySecret:
                                properties:
                                  key:
                                    type: string
                                  name:
                                    type: string
                                  optional:
                                    type: boolean
                                required:
                                  - key
                                type: object
                            type: object
                          endpoint:
                            type: string
                          insecure:
                            type: boolean
                          key:
                            type: string
                          region:
                            type: string
                          roleARN:
                            type: string
                          secretKeySecret:
                            properties:
                              key:
                                type: string
                              name:
                                type: string
                              optional:
                                type: boolean
                            required:
                              - key
                            type: object
                          useSDKCreds:
                            type: boolean
                        type: object
                      subPath:
                        type: string
                    required:
                      - name
                    type: object
                  type: array
                exitCode:
                  type: string
                parameters:
                  items:
                    properties:
                      default:
                        type: string
                      description:
                        type: string
                      enum:
                        items:
                          type: string
                        type: array
                      globalName:
                        type: string
                      name:
                        type: string
                      value:
                        type: string
                      valueFrom:
                        properties:
                          configMapKeyRef:
                            properties:
                              key:
                                type: string
                              name:
                                type: string
                              optional:
                                type: boolean
                            required:
                              - key
                            type: object
                          default:
                            type: string
                          event:
                            type: string
                          expression:
                            type: string
                          jqFilter:
                            type: string
                          jsonPath:
                            type: string
                          parameter:
                            type: string
                          path:
                            type: string
                          supplied:
                            type: object
                        type: object
                    required:
                      - name
                    type: object
                  type: array
                result:
                  type: string
              type: object
            phase:
              type: string
            progress:
              type: string
          required:
            - metadata
          type: object
      served: true
      storage: true
