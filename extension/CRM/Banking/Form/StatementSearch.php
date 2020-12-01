<?php

/*-------------------------------------------------------+
| Project 60 - CiviBanking                               |
| Copyright (C) 2020 SYSTOPIA                            |
| Author: B. Zschiedrich                                 |
| http://www.systopia.de/                                |
+--------------------------------------------------------+
| This program is released as free software under the    |
| Affero GPL v3 license. You can redistribute it and/or  |
| modify it under the terms of this license which you    |
| can read by viewing the included agpl.txt or online    |
| at www.gnu.org/licenses/agpl.html. Removal of this     |
| copyright header is strictly prohibited without        |
| written permission from the original author(s).        |
+--------------------------------------------------------*/

use CRM_Banking_ExtensionUtil as E;

class CRM_Banking_Form_StatementSearch extends CRM_Core_Form
{
    const VALUE_DATE_START_ELEMENT = 'value_date_start';
    const VALUE_DATE_END_ELEMENT = 'value_date_end';
    const BOOKING_DATE_START_ELEMENT = 'booking_date_start';
    const BOOKING_DATE_END_ELEMENT = 'booking_date_end';
    const MINIMUM_AMOUNT_ELEMENT = 'minimum_amount';
    const MAXIMUM_AMOUNT_ELEMENT = 'maximum_amount';
    const STATUS_ELEMENT = 'maximum_status';

    public function buildQuickForm()
    {
        // TODO: Aus data_parsed (JSON) suchen: Was denn?
        // -> Fünf Felder zur freien Eingabe von Parametername und Wert.

        $this->buildSearchElements();

        $this->addButtons(
            [
                'type' => 'find',
                'name' => E::ts('Find'),
                'icon' => 'fa-search',
                'isDefault' => true,
            ]
        );

        // Pass the AJAX URL to the Javascript frontend:
        CRM_Core_Resources::singleton()->addVars(
            'banking_transaction_search',
            [
                'data_url' => CRM_Utils_System::url('civicrm/banking/statements/search/data/'),
            ]
        );

        parent::buildQuickForm();
    }

    private function buildSearchElements()
    {
        // TODO: These two dates should be horizontally aligned with a '-' between them:
        $this->add(
            'datepicker',
            self::VALUE_DATE_START_ELEMENT,
            E::ts('Value Date start'),
            [
                'formatType' => 'activityDateTime'
            ]
        );
        $this->add(
            'datepicker',
            self::VALUE_DATE_END_ELEMENT,
            E::ts('Value Date end'),
            [
                'formatType' => 'activityDateTime'
            ]
        );

        // TODO: These two dates should be horizontally aligned with a '-' between them:
        $this->add(
            'datepicker',
            self::BOOKING_DATE_START_ELEMENT,
            E::ts('Booking Date start'),
            [
                'formatType' => 'activityDateTime'
            ]
        );

        $this->add(
            'datepicker',
            self::BOOKING_DATE_END_ELEMENT,
            E::ts('Booking Date end'),
            [
                'formatType' => 'activityDateTime'
            ]
        );

        // TODO: These two text fields should be horizontally aligned with a '-' between them:
        $this->add(
            'text',
            self::MINIMUM_AMOUNT_ELEMENT,
            E::ts('Minimum amount')
        );

        $this->add(
            'text',
            self::MAXIMUM_AMOUNT_ELEMENT,
            E::ts('Maximum amount')
        );

        $statusApi = civicrm_api3(
            'OptionValue',
            'get',
            [
                'option_group_id' => 'civicrm_banking.bank_tx_status',
                'options' => ['limit' => 0]
            ]
        );

        $statuses = [];
        foreach ($statusApi['values'] as $status) {
            $statuses[$status['id']] = $status['name'];
        }

        $this->add(
            'select',
            self::STATUS_ELEMENT,
            E::ts('Status'),
            $statuses,
            false,
            [
                'class' => 'crm-select2 huge',
                'multiple' => true,
            ]
        );

        // TODO: Which currency -> Is there a currency picker? -> Otherwise list picker
        // TODO: Which ba_id (receiver/target account) -> Look at how Banking does that!
        // TODO: Which party_ba_id (sender/party account) -> Look at how Banking does that!
    }

    private function buildButtons()
    {
        // TODO: Implement.
    }

    public function postProcess()
    {
        parent::postProcess();
    }

    public static function getTransactionsAjax()
    {
        $ajaxParameters = CRM_Core_Page_AJAX::defaultSortAndPagerParams();
        $ajaxParameters += CRM_Core_Page_AJAX::validateParams(
            [], // No required parameters
            [
                self::VALUE_DATE_START_ELEMENT => 'String',
                self::VALUE_DATE_END_ELEMENT => 'String',
                self::BOOKING_DATE_START_ELEMENT => 'String',
                self::BOOKING_DATE_END_ELEMENT => 'String',
                self::MINIMUM_AMOUNT_ELEMENT => 'Integer',
                self::MAXIMUM_AMOUNT_ELEMENT => 'Integer',
                self::STATUS_ELEMENT => '', // FIXME: Array of String?
            ]
        );

        $queryParameters = [];
        $whereClauses = '';

        if (isset($ajaxParameters[self::VALUE_DATE_START_ELEMENT])) {
            $parameterCount = count($queryParameters) + 1;

            $whereClauses += "AND DATE(tx.value_date) >= DATE(%{$parameterCount})";

            $valueDateStart = $ajaxParameters[self::VALUE_DATE_START_ELEMENT];
            $queryParameters[$parameterCount] = [$valueDateStart, 'Date'];
        }
        if (isset($ajaxParameters[self::VALUE_DATE_END_ELEMENT])) {
            $parameterCount = count($queryParameters) + 1;

            $whereClauses += "AND DATE(tx.value_date) <= DATE(%{$parameterCount})";

            $valueDateEnd = $ajaxParameters[self::VALUE_DATE_END_ELEMENT];
            $queryParameters[$parameterCount] = [$valueDateEnd, 'Date'];
        }

        if (isset($ajaxParameters[self::BOOKING_DATE_START_ELEMENT])) {
            $parameterCount = count($queryParameters) + 1;

            $whereClauses += "AND DATE(tx.booking_date) >= DATE(%{$parameterCount})";

            $bookingDateStart = $ajaxParameters[self::BOOKING_DATE_START_ELEMENT];
            $queryParameters[$parameterCount] = [$bookingDateStart, 'Date'];
        }
        if (isset($ajaxParameters[self::BOOKING_DATE_END_ELEMENT])) {
            $parameterCount = count($queryParameters) + 1;

            $whereClauses += "AND DATE(tx.booking_date) <= DATE(%{$parameterCount})";

            $bookingDateEnd = $ajaxParameters[self::BOOKING_DATE_END_ELEMENT];
            $queryParameters[$parameterCount] = [$bookingDateEnd, 'Date'];
        }

        if (isset($ajaxParameters[self::MINIMUM_AMOUNT_ELEMENT])) {
            $parameterCount = count($queryParameters) + 1;

            $whereClauses += "AND tx.amount >= %{$parameterCount}";

            $minimumAmount = $ajaxParameters[self::MINIMUM_AMOUNT_ELEMENT];
            $queryParameters[$parameterCount] = [(int)$minimumAmount, 'Integer'];
        }
        if (isset($ajaxParameters[self::MAXIMUM_AMOUNT_ELEMENT])) {
            $parameterCount = count($queryParameters) + 1;

            $whereClauses += "AND tx.amount <= %{$parameterCount}";

            $maximumAmount = $ajaxParameters[self::MAXIMUM_AMOUNT_ELEMENT];
            $queryParameters[$parameterCount] = [(int)$maximumAmount, 'Integer'];
        }

        if (isset($ajaxParameters[self::STATUS_ELEMENT])) {
            // TODO: Implement

            //$parameterCount = count($queryParameters) + 1;

            //$whereClauses += "AND tx.status_id IN (%{$parameterCount})";

            //$status = $ajaxParameters[self::STATUS_ELEMENT]; // TODO: How to get the list of values/IDs?
            //$queryParameters[$parameterCount] = [$status, 'Integer'];
        }

        // FIXME: "tx.*" is not safe! We must explicitely name the things we want to get here!
        $sql =
        "SELECT
            tx.*,
            DATE(tx.value_date) AS `date`,
            tx_status.name AS status_name,
            tx_status.label AS status_label
        FROM
            civicrm_bank_tx AS tx
        LEFT JOIN
            civicrm_option_value AS tx_status
                ON
                    tx_status.id = tx.status_id
        WHERE
            TRUE
            {$whereClauses}
        ORDER BY
            tx_status.weight,
            tx.value_date
        LIMIT 10";

        $transactionDao = CRM_Core_DAO::executeQuery($sql, $queryParameters);

        $fetchAllResult = $transactionDao->fetchAll();

      CRM_Utils_JSON::output(
        [
          'data'            => $fetchAllResult,
          'recordsTotal'    => count($fetchAllResult),
          'recordsFiltered' => count($fetchAllResult), // todo: correct value
        ]
      );
    }
}
