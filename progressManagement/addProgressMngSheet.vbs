Option Explicit

Sub addProgressMngSheet()
    Dim mcrWb As MacroWorkBook
    Set mcrWb = New MacroWorkBook
    Dim tstSpcfctn As TestSpecification
    Set tstSpcfctn = New TestSpecification
    '//�i���Ǘ��\�V�[�g��
    Dim addWsName As String
    
    Application.ScreenUpdating = False
    
    tstSpcfctn.setPath (Workbooks(mcrWb.getMacroWbName).Worksheets(mcrWb.getMacroWsName).Range("C2").Value)
    addWsName = Workbooks(mcrWb.getMacroWbName).Worksheets(mcrWb.getMacroWsName).Range("C3").Value
    '//�V�[�g�ǉ��Ώە⎎���d�l�����擾����
    tstSpcfctn.setTestSpecificationName (Dir(tstSpcfctn.getPath() & "*.xls*"))
    '//�擾���������d�l���̌�����0���������Ƃ��̃G���[�n���h�����O
    If tstSpcfctn.getTestSpeceficationName = "" Then
        MsgBox "�����d�l����" & tstSpcfctn.getPath() & "�ɑ��݂��܂���"
        Exit Sub
    End If
    ''//�����d�l���̃u�b�N�����ԂɊJ��
    '�t�@�C�����������J��
    Do While tstSpcfctn.getTestSpecificationName <> ""
        Call tstSpcfctn.openTestSpecification
        '//�ǉ�����V�[�g�Ɠ����̃V�[�g�����݂����Ƃ��͍폜����
        If tstSpcfctn.isSheetDuplicationCheck(addWsName) = True Then
            '//�u�b�N�����L���r���I���`�F�b�N�B���L�ł���Δr���I�ɂ���B
            If Workbooks(tstSpcfctn.getTestSpecificationName()).MultiUserEditing = True Then
               '//���L���O��
                Workbooks(tstSpcfctn.getTestSpecificationName()).UnprotectSharing
                Workbooks(tstSpcfctn.getTestSpecificationName()).ExclusiveAccess
            End If
            '//�V�[�g�폜
            Application.DisplayAlerts = False
            Workbooks(tstSpcfctn.getTestSpecificationName()).Worksheets(addWsName).Delete
            Application.DisplayAlerts = True
            '//���L�ɂ���
            '//Workbooks(tstSpcfctn.getTestSpecificationName()).ProtectSharing
        End If
        Call addNewWorksheets(addWsName)
        Call closeTestingSpecification
        tstSpcfctn.getTestSpecificationName = Dir()
    Loop
    
    Application.ScreenUpdating = True
    MsgBox "�V�[�g�̒ǉ����������܂����B"
End Sub
