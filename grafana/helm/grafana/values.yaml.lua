output = {
    global={
        application={
            links={
                { description= "grafana web ui",
                  url=Var.Values.hostname
                }
            }
        }
    },
    grafana={
        admin={
            password=dedupe(Var, "grafana.grafana.admin.password", randAlphaNum(14)),
            user='admin'
        },
        ingress={
            annotations={},
            tls={
                {
                    hosts={
                        Var.Values.hostname,
                    },
                    secretName='grafana-tls'
                }
            },
            hosts={
                Var.Values.hostname
            }
        },
        ["grafana.ini"]={
            server={
                root_url="https://" .. default("grafana.onplural.sh", Var.Values.hostname),
            },
        },
    },
}

if Var.Provider == "kind" then
    output.grafana.ingress.annotations = {
        ['external-dns.alpha.kubernetes.io/target']='127.0.0.1'
    }
end

if Var.SMTP ~= nil then
    output.secret={
        smtp={
            enabled=true,
            user=Var.SMTP.User,
            password=Var.SMTP.Password
        }
    }
    output.grafana.smtp={
        existingSecret='grafana-smtp-credentials',
        userKey= "user",
        passwordKey= "password",
    }
    grafana_ini = output.grafana["grafana.ini"]
    grafana_ini.smtp={
        enabled=true,
        host= Var.SMTP.Server .. ":" .. Var.SMTP.Port,
        from_address=Var.SMTP.Sender
    }
end

if Var.OIDC ~= nil then
    grafana_ini = output.grafana["grafana.ini"]
    grafana_ini["auth.generic_oauth"]={
        name='Plural',
        enabled=true,
        allow_sign_up=true,
        client_id=Var.OIDC.ClientId,
        client_secret=Var.OIDC.ClientSecret,
        scopes='openid profile',
        auth_url=Var.OIDC.Configuration.AuthorizationEndpoint,
        token_url=Var.OIDC.Configuration.TokenEndpoint,
        api_url=Var.OIDC.Configuration.UserinfoEndpoint,
        role_attribute_path="null",
        groups_attribute_path='groups'
    }
end

if Var.Configuration then
    if Var.Configuration.loki then
        output.grafana.datasources={
            ["datasources.yaml"]={
                apiVersion=1,
                deleteDatasources={
                    {
                        name='Loki',
                        orgId=1
                    }
                }
            }
        }
    end
end

if Var.Values.usePostgres then
    output.grafana.env={
        ['GF_DATABASE_TYPE']='postgres',
        ['GF_DATABASE_HOST']='plural-postgres-grafana',
        ['GF_DATABASE_NAME']='grafana',
        ['GF_DATABASE_USER']='grafana',
        ['GF_DATABASE_SSL_MODE']='require'
    }

    output.grafana.envValueFrom={
        GF_DATABASE_PASSWORD={
            secretKeyRef={
                name='grafana.plural-postgres-grafana.credentials.postgresql.acid.zalan.do',
                key='password'
            }
        }
    }

    output.postgres={
        enabled=true
    }
end
