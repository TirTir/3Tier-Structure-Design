# ELB(ALB|NLB) - ASG(EC2 x 2) - DB(클러스터)

<p align="center">
  <br/>
  <img src="https://github.com/user-attachments/assets/50c8cb95-0eb0-44a1-b45e-a5d960875a3f" width="400" height="170">
  <br/>
</p>

### 프로젝트 소개
---

#### 3-Tier 아키텍처란?
<p>
  <br/>
  <img src="https://github.com/user-attachments/assets/0d0fecbf-f84a-46d1-9b0e-2b639095e56c" width="400" height="150">
  <br/>
</p>

어떠한 플랫폼이나 애플리케이션을 3계층으로 나누어 별도의 논리적/물리적인 장치에 구축 및 운영하는 형태입니다.

보통 **프레젠테이션 계층, 어플리케이션 계층, 데이터 계층**으로 분리합니다.

- **프젠테이션 계층**
  - 사용자가 애플리케이션과 상호작용하는 인터페이스
  - 일반적으로 HTML, JS, CSS 등이 이 계층에 포함되며, 프론트엔드라고 불립니다.

- **애플리케이션 계층**
  - 요청되는 정보를 어떠한 규칙에 따라 처리하고 가공한다.
  - 백엔드라고 불립니다.
  
- **데이터 계층**
  - 데이터 베이스와 데이터 베이스에 접근하여 데이터를 CRUD 합니다.
<p>
  <br/>
</p>

### 시스템 구성도

---

<p align="center">
  <img src="https://github.com/user-attachments/assets/e1c8889f-0a97-4bef-813b-d1f8f46ba5c2" width="400" height="520">
  <br/>
  <br/>
</p>

### 구현 기능

---

**1. VPC 및 서브넷 설정**

```plaintext
project/
└── vpc/
    ├── vpc.tf
    ├── subnets.tf
    ├── internet-gateway.tf
    ├── nat-gateway.tf
    ├── route-table.tf
    ├── variable.tf
    └── outputs.tf
```

#### **라우팅 테이블**
- 라우팅 테이블은 **ip 주소에 대한 라우팅 경로를 설정**합니다.
- Public과 Private을 나눠 설정하고 각각 Public, Private 서브넷에 연결한 후, 외부에서 내부로의 접근이 가능하도록 Public 서브넷만 인터넷 게이트와 연결합니다.

**2. 보안 그룹 설정**

* **Source**: 출발지, cidr_blocks 또는 Security Group
* **Port**: Source에서 들어오는 Port Number

#### **[ vpc-security-group (VPC SG) ]**

| **Security Group** | **Type**  | **Protocol** | **Port** | **Source**      |
|-------------------|-----------|--------------|----------|----------------|
| INGRESS            | SSH       | TCP          | 22       | 내 IP           |
| INGRESS            | HTTP      | TCP          | 80       | 내 IP           |
| INGRESS            | ICMP      | ICMP         | -1       | 내 IP           |


#### **[ web-security-group (WEB SG) ]**

| **Security Group** | **Type**  | **Protocol** | **Port** | **Source**      |
|-------------------|-----------|--------------|----------|----------------|
| INGRESS            | SSH       | TCP          | 22       | VPC SG          |
| INGRESS            | HTTP      | TCP          | 80       | 0.0.0.0/0       |

#### **[ was-security-group (WAS SG) ]**

| **Security Group** | **Type**  | **Protocol** | **Port** | **Source**      |
|-------------------|-----------|--------------|----------|----------------|
| INGRESS            | SSH       | TCP          | 22       | VPC SG          |
| INGRESS            | Custom TCP| TCP          | 8080     | 10.0.11.0/24, 10.0.12.0/24 |

#### **[ rds-security-group (RDS SG) ]**

| **Security Group** | **Type**  | **Protocol** | **Port** | **Source**      |
|-------------------|-----------|--------------|----------|----------------|
| INGRESS            | MYSQL     | TCP          | 3306     | WAS SG          |
| INGRESS            | Custom TCP| TCP          | 8080     | LB SG           |

<p>
  <br/>
</p>

**3. EC2 인스턴스 및 오토 스케일링 설정**

```plaintext
project/
└── ec2/
    ├── instance.tf
    ├── bastion_instance.tf
    ├── autoscaling.tf
    ├── launch_configuration.tf
    ├── variable.tf
    └── outputs.tf
```

- Bastion 호스트, 웹 서버, 애플리케이션 서버를 AWS EC2 인스턴스로 배포하고, 오토 스케일링을 통해 트래픽 증가에 따라 인스턴스를 자동으로 조정합니다.

<p>
  <br/>
</p>

**4. 로드 밸런서 설정**

```plaintext
project/
└── alb/
    ├── alb.tf
    ├── listener.tf
    ├── target_group.tf
    └── variable.tf
```

#### **ALB → HTTP 및 HTTPS 트래픽 로드밸런싱**
- 인터넷 게이트웨이로 들어온 트래픽을 WEB으로 분산시킵니다.
- 가용영역을 public 서브넷으로 설정하고 vpc 보안그룹을 사용합니다.
- HTTP 프로토콜의 80포트를 타고 타겟을 찾아가도록 설정하였으며, 타겟 그룹은 private 서브넷으로 설정하였습니다.

#### **Public -> application-load-balancing**
- 내부 WEB으로 들어온 트래픽을 WAS로 분산시킵니다.
- 가용영역은 private 서브넷(web instance)로 설정하고 web 보안그룹 사용을, 타겟 그룹은 private 서브넷(was instance)으로 설정하였습니다.

<p>
  <br/>
</p>


이 프로젝트의 상세한 문서는 아래 링크에서 PDF 파일로 확인할 수 있습니다.

[프로젝트 문서 보기](3Tier-Structure-Design/3Tier-Structure-Design_김유진_2023_1126.pdf)
