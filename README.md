# Portfolio-From-Sep-2023
> [!IMPORTANT]
> **アピールポイント**  
> このアプリケーションは、Terraform Cloudで最先端のIaC技術を使用しデザインされています。環境の再現性、迅速な構築、そして一貫性のある変更管理により、ビジネスの変化や要件の変動に柔軟に対応します。  
> アプリケーション実行環境としてECS on Fargateを採用し、リソースの伸縮や管理の手間を大幅に削減しつつ、トラフィックの変動に応じて自動的にスケーリングします。  
> 最後にこのクラウド基盤は、個人開発経験と実務経験をベースに構築されています。私はこの技術力と経験を活かし、ビジネスの成長と変化に柔軟に対応する強固な基盤を構築することができます。  
> **この文言は、トップページの生成AIで作成した動画アバターのスクリプトとしても使用**
  
> [!NOTE]
> **想定閲覧者**  
> このREADME.mdに記載されている基本設計書は、顧客ではなく技術者を想定閲覧者として作成されています。  
> したがって、例えば基本設計書内の「セキュリティ設計」の部分にIAMの具体的なセキュリティ機能の説明は省き技術選定内にIAMと記載するに留めることで、想定閲覧者の文章を読む負担を軽減するように設計されています。  
  
# 目次
1. はじめに
1. 技術選定
    1. クラウドインフラ
        1. クラウド基盤共通
        1. サーバレス環境
        1. データ分析基盤
    1. 開発ツール
    1. バックエンド
    1. フロントエンド
    1. 生成AI（動画・静止画・コード生成）
1. 基本設計
    1. クラウドインフラ
    1. バックエンド
1. その他
  
---------------------------------------
# はじめに
はじめに  
  
---------------------------------------
# 技術選定
## 技術選定　＞　クラウドインフラ　＞　クラウド基盤共通
IaC）Terraform Cloud  
管理コンソールから作成したサービス）
  
IaCで作成したサービス）ECS on Fargate, RDS, ECR, ACM, ALB, VPC（IPv4）, IAM, S3, CloudFront, WAF, CloudWatch log, Route53, VPC Flow Logs, AWS Config, KMS, Athena, Amazon Inspector, Guard Duty, Trusted Advisor, 
  
初期設定で使用が有効で、継続使用を判断したサービス）CloudTrail, AWS Shield Standard, 
  
## 技術選定　＞　クラウドインフラ　＞　サーバレス環境
+ Python 3.11.5 (サーバレス環境およびデータ分析基盤の構築用)
  
## 技術選定　＞　クラウドインフラ　＞　データ分析基盤

  
## 技術選定　＞　開発ツール
+ Docker
+ AWS CLI(オートコンプリート)
  
## 技術選定　＞　バックエンド
+ PHP 8.2.10  
+ Laravel 10.22.0  
  
## 技術選定　＞　フロントエンド
+ Bootstrap（下記生成AIにより、95%以上を自動生成）  
+ HTML/CSS（下記生成AIにより、95%以上を自動生成）
  
## 技術選定　＞　生成AI（動画・静止画・コード生成）
+ Creative Reality Studio（写真とテキストを入力し、しゃべるアバター動画を出力するAI。トップページの動画を生成）  
+ DiffusionBee（テキストを入力し、画像を出力するAI。favicon.icoを生成）  
+ ChatGPT（version4）　HTML/CSS/Bootstrapを生成

  
---------------------------------------
# 基本設計
## 基本設計　＞　クラウドインフラ

  
## 基本設計　＞　バックエンド
**（簡易版）アプリケーション実装機能**  
+ CRUD機能  
+ 検索機能  
+ ページネーション機能  
+ バリデーション  
+ ユーザー登録、ログイン
  
---------------------------------------
## その他

  
