/*
This file is part of Cloud Native PostgreSQL.

Copyright (C) 2019-2020 2ndQuadrant Italia SRL. Exclusively licensed to 2ndQuadrant Limited.
*/

package specs

import (
	rbacv1 "k8s.io/api/rbac/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"

	"github.com/2ndquadrant/cloud-native-postgresql/api/v1alpha1"
)

// CreateRole create a role with the permissions needed by PGK
func CreateRole(cluster v1alpha1.Cluster) rbacv1.Role {
	return rbacv1.Role{
		ObjectMeta: metav1.ObjectMeta{
			Namespace: cluster.Namespace,
			Name:      cluster.Name,
		},
		Rules: []rbacv1.PolicyRule{
			{
				APIGroups: []string{
					"postgresql.k8s.2ndq.io",
				},
				Resources: []string{
					"clusters",
				},
				Verbs: []string{
					"get",
					"watch",
				},
				ResourceNames: []string{
					cluster.Name,
				},
			},
			{
				APIGroups: []string{
					"postgresql.k8s.2ndq.io",
				},
				Resources: []string{
					"clusters/status",
				},
				Verbs: []string{
					"get",
					"patch",
					"update",
					"watch",
				},
				ResourceNames: []string{
					cluster.Name,
				},
			},
		},
	}
}