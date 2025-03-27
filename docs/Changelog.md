# Utility Hub Changelog

> Welcome to the **Utility Hub** changelog! Here’s a look at the journey of this project, from early features to big improvements and exciting experiments along the way. Utility Hub is a React web app hosted on AWS S3 with an AWS Lambda backend, designed to bring together some useful personal tools.

---

### Latest Updates

#### [changing-domain-to-bengigitalpro.com] - February 2025
- **Domain Name Migration**:Users should now use the base domain of bendigitalpro.com to access the QA and production website

#### [add-global-setting-storage] - November 2024
- **Global Settings Storage**: Now users can save their settings across tools! This makes it easier to keep user configurations consistent across features.

#### [implement-crypto-feature] - November 2024
- **Crypto Tracking**: Started building a cryptocurrency tracker to keep tabs on balances and transactions, making it easy to track your crypto holdings over time.
It integrates with crypto exchanges like Binance and Crypto.com to fetch real-time prices.

#### [remove-slack-feature] - October 2024
- **Slack Integration Removed**: Removed Slack monitoring, as it didn’t quite fit with where Utility Hub is heading.

#### [add-dynamic-vpc-setup] - July-August 2024
- **Flexible VPC Setup**: Added a switch to control VPC deployment. So now, if you’re looking to save on costs, you can skip the VPC (but it’s ready to go for secure deployments when needed).


#### [implement-json-yaml-format] - January-February 2024
- **JSON/YAML Formatter**: Added tools to work with JSON files, making it easier to handle these files during my day-to-day work.

#### [remove-waf-for-cost-reduction] - December 2023
- **WAF Removal**: Cut down on costs by removing the Web Application Firewall (WAF). We can re-enable it anytime we need the extra security.

#### [refactor-terraform-to-use-modules] - October-November 2023
- **Terraform Modules**: Cleaned up Terraform code by organizing it into modules. This makes it way easier to manage and re-use.

#### [Move_all_resources_inside_a_VPC] - September-October 2023
- **VPC Migration**: Moved everything inside a VPC for better security and compliance, ensuring things are more isolated and secure.

#### [refactor-front-end-add-auth-context] - August 2023
- **Enhanced Authentication**: Added an authentication context to the frontend, making it easier to manage user sessions securely.

#### [implement-chrome-extension] - August 2023
- **Chrome Extension (Paused)**: Kicked off a Chrome Extension project to give users quick access to tools while browsing. This one’s on hold for now but could come back in the future.

#### [implement-trading-utility] - August 2023
- **Trading Analysis Tool (Paused)**: Started work on a trading tool with historical crypto data and analysis, but had to pause to focus on other priorities.

#### [implement-bookmarks-feature] - August 2023
- **Bookmarks Manager**: Users can now save and organize links in the platform – perfect for keeping everything in one place.

#### [add-common-folder-backend] - July 2023
- **Backend Code Organization**: Created a shared folder for backend code, so common logic is easy to manage and deploy across lambda functions.

#### [refactor-UI-for-link-manager] - July 2023
- **Link Manager Redesign**: Updated the Link Manager’s look and feel to make it easier and nicer to use.

#### [Implement-Slack-feature] - June-July 2023
- **Slack Monitoring Tool**: Created a bot to monitor and graph message activity in Slack channels, making it easier to spot patterns like possible outage alerts.

#### [refactor-to-micro-service-architecture] - June-July 2023
- **Microservices Refactor**: Restructured the app into microservices by splitting features into separate Lambda functions, which should help with scaling and maintenance.


#### [Implement-login-UI-using-MUI] - April-May 2023
- **Login UI Overhaul**: Revamped the login interface using Material-UI for a more polished and user-friendly look.

#### [Implement-login] - April 2023
- **Login Logic**: Set up backend login with Google and session management using JWT tokens for secure access.

---

This changelog gives a look at how Utility Hub has grown, with plenty of features, improvements, and ideas still to come. Thanks for following along!
