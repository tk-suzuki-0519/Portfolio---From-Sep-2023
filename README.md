# :fire:Portfolio-From-Sep-2023:fire:
> [!IMPORTANT]
> **アピールポイント**  
> IaCとして、Terraform Cloudを使用。
> クラウドサービス・機能としては、ECS on Fargate, ECR, CloudFront, RDSなどを使用。
  
> [!NOTE]
> **想定閲覧者**  
> このREADME.mdに記載されている基本設計書は、顧客ではなく技術者を想定閲覧者として作成されています。  
> したがって、例えば基本設計書内の「セキュリティ設計」の部分にIAMの具体的なセキュリティ機能の説明は冗長的になるため省き、技術選定欄にサービス名としてIAMと記載するに留めることで想定閲覧者の文章を読む負担を軽減するように設計されています。
  
# 目次
1. [:fire:はじめに](#はじめに)
1. [:fire:技術選定](#技術選定)
    1. クラウドインフラ
        1. [クラウド基盤共通](#技術選定クラウドインフラクラウド基盤共通)
        1. [サーバレス環境(未実装)](#技術選定クラウドインフラサーバレス環境)
    1. [開発ツール](#技術選定開発ツール)
    1. [バックエンド](#技術選定バックエンド)
    1. [フロントエンド](#技術選定フロントエンド)
    1. [生成AI（動画・静止画・コード生成）](#技術選定生成ai動画静止画コード生成)
1. [:fire:基本設計](#基本設計)
    1. [クラウドインフラ](#基本設計クラウドインフラ)
    1. [コンテナ（簡易版）](#基本設計コンテナ簡易版)
    1. アプリケーション（簡易版）
        1. [実装機能（バックエンド）](#基本設計アプリケーション実装機能バックエンド)
    1. [データベース](#基本設計データベース)
1. [:fire:その他](#その他)
  
---------------------------------------
# :fire:はじめに
はじめに  
  
---------------------------------------
# :fire:技術選定
## 技術選定／クラウドインフラ
### 技術選定／クラウドインフラ／クラウド基盤共通
+ IaC）
  - Terraform Cloud
  
+ 管理コンソールから作成・有効化したサービス・機能）
  - AWS IAM(管理ユーザ作成のみ), Amazon Route 53(ドメイン登録のみ), 
  
+ IaCで作成したサービス・機能）
  - Web app)
    - Amazon ECR, Amazon ECS(AWS Fargate, AWS Auto Scaling), Elastic Load Balancing(ALB), Amazon VPC(IPv4), Amazon S3, Amazon RDS, Amazon Route 53, Amazon CloudFront, 
  - セキュリティ・ログ・その他)
    - Amazon CloudWatch Logs, AWS IAM, AWS Systems Manager(ECSExec, DB password), AWS Certificate Manager, 
  
+ 初期設定で有効化されているサービス・機能）
  - コスト管理サービス・機能）
    - AWS billing Alarms, AWS Budget, AWS Cost Explorer, 
  
<!-- 
+ IaCで作成したサービス・機能） WAF, VPC Flow Logs, AWS Config, KMS, Athena, Amazon Inspector, Guard Duty, Config, Security Hub, GuardDuty, Macie, Detective, Network Firewall, 
+ 初期設定で有効化されているサービス・機能）  CloudTrail, AWS Shield Standard, AWS Health Dashboard,
-->
  
<!--
### 技術選定／クラウドインフラ／サーバレス環境
+ Python 3.11.5 (サーバレス環境およびデータ分析基盤の構築用)
  
  
### 技術選定／クラウドインフラ／データ分析基盤
-->
  
## 技術選定／開発ツール
+ Docker Desktop 4.25.0
+ aws-cli 2.13.27(オートコンプリート, Session Manager plugin for the AWS CLI)
+ Terraform v1.6.2(CLI環境)
+ pyenv 2.3.27
  
## 技術選定／バックエンド
+ PHP 8.2.10  
+ Laravel 10.22.0  
  
## 技術選定／フロントエンド
<!-- 
+ Bootstrap（下記生成AIにより、95%以上を自動生成）
+ HTML/CSS（下記生成AIにより、95%以上を自動生成）
-->
  
## 技術選定／生成AI（動画・静止画・コード生成）
<!-- 
+ Creative Reality Studio（写真とテキストを入力し、しゃべるアバター動画を出力するAI。トップページの動画を生成）
+ DiffusionBee（favicon.icoを生成。テキストを入力し、画像を出力するAI。）
+ ChatGPT（version4）　HTML/CSS/Bootstrapを生成
-->
  
  
---------------------------------------
# :fire:基本設計
## 基本設計／クラウドインフラ
  
  
## 基本設計／コンテナ（簡易版）
+ nginx 1.25.3
+ mysql 8.1.0
+ php 8.2.10-fpm
  
## 基本設計／アプリケーション（簡易版）
### 基本設計／アプリケーション／実装機能（バックエンド）
現状初期設定完了
<!-- 
+ CRUD機能
+ 検索機能
+ ページネーション機能
+ バリデーション
+ ユーザー登録、ログイン
-->
  
## 基本設計／データベース
<!--
+ テーブル設計（簡易版）  
ER図  
-->
  
---------------------------------------
# :fire:その他
  
  