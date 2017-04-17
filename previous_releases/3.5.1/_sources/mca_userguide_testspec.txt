********************
Test Spec
********************

.. |editbutton| image:: images/mca/editbutton.png

.. image:: images/mca/testspecs.png

Test specs are set of parameters used by a particular test services. Instead of defining such parameters for each tests that you want to run,
you can define them under Test Specs tab, and use them by referencing it from each tests defined under Configs tab.

Click "Add New" button to open a test spec editor, or can click on a small pencil button |editbutton| to edit an existing test spec.

.. image:: images/mca/testspec.png

* Name: Name of the hostgroup
* Service Type: Service type that this parameter set applies. This field is preselected when you click on "Add New" button.
* Admins: List of users who are admin of this test spec. Only admins can edit the hosts.
* Depenending on the service type, you will see different set of test specs that you can enter. Please read comments on the UI for details about each parameter.

Please see :doc:`mca_userguide_config` next.

