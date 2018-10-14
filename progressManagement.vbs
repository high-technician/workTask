Sub makeAggregateTable()
    '�e�����d�l���̂Ƀo���G�[�V�������Ǘ����邽�߂̊Ǘ��V�[�g���쐬����B
    Dim macroWbName As String                           '�}�N���̃u�b�N��
    Dim macroWsName As String                           '�}�N���̃V�[�g��
    Dim path As String                                            '�����d�l���̔z�u�f�B���N�g��
    Dim wbNum As Integer                                     '�����d�l����
    Dim wbName As String                                     '�����d�l���̃u�b�N��
    Dim wsName As String                                     '�����d�l���̃V�[�g��
    Dim executingDate As String                            '���s��
    Dim variationKW As String                                '�o���G�[�V�����G���A��T�����߂̃L�[���[�h
    Dim ws As Worksheets                                      '�H
    Dim inputedexecutingDateCell As Range         '���s������`����Ă���Z��
    Dim toCellsInVariationRng As Range                '�o���G�[�V�����G���A�̍���̃Z��
    Dim variationRng As Range                              '�o���G�[�V�����G���A
    Dim variationMaxNum As Integer                     '�o���G�[�V�����̍ő吔
    Dim testCaseNum As Integer                           '�e�X�g�P�[�X��
    Dim toCellsInVariationRngRow As Integer       '�o���G�[�V�����G���A�̍���̃Z���̍s�ԍ�
    Dim toCellsInVariationRngColumn As Integer  '�o���G�[�V�����G���A�̍���̃Z���̗�ԍ�
    Dim endCellsInVariationRng As Range             '�o���G�[�V�����G���A�̉E���̃Z��
    Dim columnId As String                                    '�Z���̗�ԍ�(�A���t�@�x�b�g)
    Dim aggregateTableName As String                '�W�v�\�̖��O
    
    '�}�N���u�b�N�̃u�b�N���A�V�[�g���A���t���A�L�[���[�h�A�����d�l������progressManageent.xlsm����擾
    macroWbName = Range("C3").Value
    macroWsName = Range("C4").Value
    Workbooks(macroWbName).Worksheets(macroWsName).Range("B10").Select
    wbNum = Range(Selection, Selection.End(xlDown)).Rows.count
    executingDate = Workbooks(macroWbName).Worksheets(macroWsName).Range("C6").Value
    variationKW = Workbooks(macroWbName).Worksheets(macroWsName).Range("C7").Value
    Debug.Print ("�}�N���̃u�b�N���F" & macroWbName)
    Debug.Print ("�}�N���̃V�[�g���F" & macroWsName)
    Debug.Print ("�����d�l�����F" & wbNum)
    Debug.Print ("���t���F" & executingDate)
    Debug.Print ("�o���G�[�V�������������邽�߂̃L�[���[�h�F" & variationKW)
    
    Dim l As Integer
    Dim count As Long
    count = 0
    For l = 0 To wbNum - 1
L1:
        '�^�[�Q�b�g�̎����d�l�����A�V�[�g���A�i���\�̂���V�[�g�����擾
        wbName = Workbooks(macroWbName).Worksheets(macroWsName).Cells(10 + l, 2).Value
        wsName = Workbooks(macroWbName).Worksheets(macroWsName).Cells(10 + l, 3).Value
        aggregateTableName = Workbooks(macroWbName).Worksheets(macroWsName).Cells(10 + l, 4).Value
        Debug.Print ("�����d�l�����F" & wbName)
        Debug.Print ("�V�[�g���F" & wsName)
        Debug.Print ("�i���\�̂���V�[�g���F" & aggregateTableName)
        
        '������قǂ܂łƎ����d�l�����قȂ�Ȃ�ΐV���������d�l�����J��
        If isSameTestingSpecification(macroWbName, macroWsName, l - 1) = False Then
            Call openTestingSpecification(getPath(macroWbName, macroWsName, "C5"), wbName)
        End If
        
        '�V�[�g���Ńo���G�[�V�����G���A����肷��
        Workbooks(wbName).Worksheets(wsName).Activate
        Set toCellsInVariationRng = findCells(variationKW, usingRng(wbName, wsName))
        
        '�o���G�[�V�����G���A�����ł��Ȃ������Ƃ��̃G���[�n���h�����O
        If toCellsInVariationRng Is Nothing Then
            MsgBox "�����d�l���F" & wbName & "�@�V�[�g���F" & wsName & "�̃o���G�[�V�����G���A�̓���Ɏ��s�Bskip���܂��B"
            l = l + 1
            GoTo L1
        End If
        
        '����ł����ꍇ�͏����𑱍s
        Set toCellsInVariationRng = Cells(findCells(variationKW, usingRng(wbName, wsName)).Row + 1, findCells(variationKW, usingRng(wbName, wsName)).Column + 1)
        Debug.Print ("�o���G�[�V�����͈̔͂̍���F" & toCellsInVariationRng.Address(RowAbsolute:=False, ColumnAbsolute:=False))
        Set variationRng = findArea(toCellsInVariationRng)
        Debug.Print ("�o���G�[�V�����͈̔́F" & variationRng.Address(RowAbsolute:=False, ColumnAbsolute:=False))
        
        '���肵���o���G�[�V�����G���A�͈̔͂���o���G�[�V�����ő吔���擾
        variationMaxNum = variationRng.Rows.count
        Debug.Print ("�o���G�[�V�����̍ő吔�F" & variationMaxNum)
        
        '���肵���o���G�[�V�����G���A�͈̔͂���e�X�g�P�[�X�����擾
        testCaseNum = variationRng.Columns.count
        Debug.Print ("�e�X�g�P�[�X���F" & testCaseNum)
        Set endCellsInVariationRng = Cells(toCellsInVariationRng.Row + variationMaxNum, toCellsInVariationRng.Column)
        
        '���s�������͂���Ă���Z���̈ʒu���擾
        Set inputedexecutingDateCell = findCells(executingDate, usingRng(wbName, wsName))
        Debug.Print ("���s�������͂���Ă���Z���̈ʒu�F" & inputedexecutingDateCell.Address(RowAbsolute:=False, ColumnAbsolute:=False))
        
        '���s�������͂���Ă���Z���̈ʒu�̓���Ɏ��s�������̃G���[�n���h�����O
        If inputedexecutingDateCell Is Nothing Then
            MsgBox "�����d�l���F" & wbName & "�@�V�[�g���F" & wsName & "�̎��s�������͂���Ă���Z���̈ʒu�̓���Ɏ��s���܂����Bskip���܂�"
            l = l + 1
            GoTo L1
        End If
        
        '�W�v�\�ɏ������݂��J�n
        Dim i As Integer
            For i = 0 To testCaseNum - 1
                Call writingInAggregateTable(i, count, aggregateTableName, wsName, toCellsInVariationRng, inputedexecutingDateCell, variationMaxNum)
            Next i
        count = count + testCaseNum
        Debug.Print ("���v���F" & count)
        
        '���������d�l�����قȂ�̂ł���Ύ����d�l����ۑ����ĕ���
        If isSameTestingSpecification(macroWbName, macroWsName, l) = False Then
            Call closeTestingSpecification(wbName)
            count = 0
        End If
        Next l
        
        MsgBox "�i���Ǘ��\�̍쐬���������܂����B"
End Sub

Sub addAggregateTable()
    '�e�����d�l���ɐi���Ǘ��\�̃V�[�g��ǉ�����B
    Dim wbName As String
    Dim wsName As String
    Dim path As String
    Dim addWsName As String
    Dim testingSpecificationName As String
    
    wbName = ActiveSheet.Range("C3").Value
    wsName = ActiveSheet.Range("C4").Value
    path = getPath(wbName, wsName, "C5")
    addWsName = Range("C6").Value
    Debug.Print ("�}�N���̃u�b�N���F" & wbName)
    Debug.Print ("�}�N���̃V�[�g���F" & wsName)
    Debug.Print ("�V�[�g�ǉ�����u�b�N���z�u����Ă���p�X�F" & path)
    'Debug.Print ("�V�[�g�ǉ�����u�b�N���F" & addWsCount)
    Debug.Print ("�V�[�g�ǉ�����u�b�N���F" & testingSpecificationName)
    
    '�V�[�g�ǉ��Ώۂ̎����d�l�����擾����
    testingSpecificationName = Dir(path & "*.xls*")
    Debug.Print ("�����d�l�����F" & testingSpecificationName)
    
    '�t�@�C�����Ȃ������Ƃ��̃G���[�n���h�����O
    If testingSpecificationName = "" Then
        MsgBox "�����d�l�������݂��܂���B"
        Exit Sub
    End If
    
    '�t�@�C�����������J��
    Do While testingSpecificationName <> ""
L2:
        Debug.Print ("�J�������d�l�����F" & testingSpecificationName)
        Call openTestingSpecification(path, testingSpecificationName)
        
        '�ǉ�����V�[�g�Ɠ����̃V�[�g�����݂����Ƃ��̃G���[�n���h�����O
        If isSheetDuplicationCheck(addWsName) = True Then
            MsgBox "�����d�l�����F" & testingSpecificationName & "�ɂ̓V�[�g���F" & addWsName & "�͂��łɑ��݂��܂��B������skip���܂��B", vbInformation
            Call closeTestingSpecification(testingSpecificationName)
            testingSpecificationName = Dir()
            
            '�擾�����Ō�̎����d�l���ɃV�[�g�����łɑ��݂��Ă������̃G���[�n���h�����O
            If testingSpecificationName = "" Then
                Exit Do
            End If
            
            '�Ō�̎����d�l���łȂ���Ώ����̍ŏ��ɖ߂��đ��s
            GoTo L2
        End If
            
        '�V�[�g��ǉ�
        Call addNewWorksheets(testingSpecificationName, addWsName)
        
        '�ǉ��ς݂̎����d�l�������B
        Call closeTestingSpecification(testingSpecificationName)
        testingSpecificationName = Dir()
    Loop
    
    MsgBox "�V�[�g�̒ǉ����������܂����B"
End Sub

Sub transcription()
    '�e���������d�l���̐i���Ǘ��\�V�[�g����}�X�^�[�֓]�L����
    Dim macroWb As String
    Dim macroWs As String
    Dim pathOfTestingSpecification As String
    Dim pathOfVariationMngWb As String
    Dim variationMngWb As String
    Dim variationMngWs As String
    Dim testingSpecification As String
    Dim aggregateTableName As String
    Dim searchWord As String
    Dim i As Long
    Dim wsName As String
    Dim caseNum As String
    Dim executingDate As String
    Dim achievement As String
    Dim remaining As String
    Dim sum As String
    Dim num As Long
    Dim overWritingFlag As Boolean
    Dim rslt As VbMsgBoxResult
    
    macroWb = ActiveSheet.Range("C3")
    macroWs = ActiveSheet.Range("C4")
    pathOfTestingSpecification = getPath(macroWb, macroWs, "C5")
    pathOfVariationMngWb = getPath(macroWb, macroWs, "C6")
    variationMngWb = ActiveSheet.Range("C7")
    variationMngWs = ActiveSheet.Range("C8")
    aggregateTableName = ActiveSheet.Range("C9")
    
    '�O�������㏑�����邩�m�F����
    rslt = MsgBox("�O�������㏑�����܂����H", Buttons:=vbYesNo)
    If rslt = vbYes Then
        overWritingFlag = True
    Else
        overWritingFlag = False
    End If
    
    '�i���Ǘ��\_�o���G�[�V����.xlsx���J��
    Call openTestingSpecification(pathOfVariationMngWb, variationMngWb)
    
    'overWritingFlag=true�̂Ƃ��A�f�[�^��O�����ڂɈړ�
    If overWritingFlag = True Then
        Workbooks(variationMngWb).Worksheets(variationMngWs).Range("E9:H10000").Copy Range("I9")
    End If
    
    '��������]�L���J�n����
    '�W�v�Ώۂ̎����d�l�������擾
    testingSpecification = Dir(pathOfTestingSpecification & "*.xls*")
    Debug.Print ("�����d�l�����F" & testingSpecification)
    
    '�t�@�C�����Ȃ������Ƃ��̃G���[�n���h�����O
    If testingSpecification = "" Then
        MsgBox "Excel�t�@�C��������܂���B"
        Exit Sub
    End If
    
    '�t�@�C�����������J��
    Do While testingSpecification <> ""
        Debug.Print ("�J�������d�l�����F" & testingSpecification)
        
        Call openTestingSpecification(pathOfTestingSpecification, testingSpecification)
        
        '�]�L����e�X�g�P�[�X�̐����v�Z����
        Workbooks(testingSpecification).Worksheets(aggregateTableName).Activate
        Workbooks(testingSpecification).Worksheets(aggregateTableName).Range("B4").Select
        num = Range(Selection, Selection.End(xlDown)).Rows.count
        Debug.Print ("�P�[�X���F" & num)
        
        For i = 0 To num - 1
L3:
            '�]�L�ɕK�v�ȏ����擾
            wsName = Cells(4 + i, 2).Value
            caseNum = Cells(4 + i, 3).Value
            executingDate = Cells(4 + i, 4).Value
            achievement = Cells(4 + i, 5).Value
            remaining = Cells(4 + i, 6).Value
            sum = Cells(4 + i, 7).Value
            
            '�]�L��̃Z���ʒu���擾
            searchWord = testingSpecification & wsName & caseNum
            Debug.Print ("�������[�h" & searchWord)
            'Workbooks(variationMngWb).Worksheets(variationMngWs).Activate
            Set copyTarget = findCells(searchWord, Workbooks(variationMngWb).Worksheets(variationMngWs).Range("T:T"))
            
            '�]�L��̃Z���ʒu���擾�ł��Ȃ������Ƃ��̃G���[�n���h�����O
            If copyTarget Is Nothing Then
                MsgBox "�����d�l�����F" & testingSpecification & "�V�[�g���F" & wsName & "�P�[�X�ԍ��F" & caseNum & "�̓]�L��̃Z���ʒu�̎擾���s�B������skip���܂��B"
                i = i + 1
                GoTo L3
            End If
            
            '�]�L
            Workbooks(variationMngWb).Worksheets(variationMngWs).Cells(copyTarget.Row, 5) = executingDate
            Workbooks(variationMngWb).Worksheets(variationMngWs).Cells(copyTarget.Row, 6) = achievement
            Workbooks(variationMngWb).Worksheets(variationMngWs).Cells(copyTarget.Row, 7) = remaining
            Workbooks(variationMngWb).Worksheets(variationMngWs).Cells(copyTarget.Row, 8) = sum
        Next i
        
        '�]�L���������������d�l�������
        closeTestingSpecification (testingSpecification)
        
        testingSpecification = Dir()
    Loop
    
    MsgBox "�]�L����"
End Sub

Function getPath(ByVal wbName As String, ByVal wsName As String, ByVal rngAddress As String) As String
    getPath = Workbooks(wbName).Worksheets(wsName).Range(rngAddress).Value
End Function

Function openTestingSpecification(ByVal path As String, ByVal wbName As String)
    Workbooks.Open (path & wbName)
    Workbooks(wbName).Activate
End Function

Function closeTestingSpecification(ByVal wbName As String)
    Application.DisplayAlerts = False
    Debug.Print ("���鎎���d�l�����F" & wbName)
    Workbooks(wbName).Save
    Workbooks(wbName).Close
    Application.DisplayAlerts = True
End Function

Function columnNumberToAlphabet(ByVal i As Long) As String
    Dim alpha As String
    alpha = Cells(1, i).Address(True, False)
    columnNumberToAlphabet = Left(alpha, InStr(alpha, "$") - 1)
End Function

Function findCells(ByVal keyword As String, ByVal usedRng As Range) As Range
    Set findCells = usedRng.Find(What:=keyword, LookIn:=xlValues, LookAt:=xlWhole)
End Function

Function usingRng(ByVal wbName As String, ByVal wsName As String) As Range
    Set usingRng = Workbooks(wbName).Worksheets(wsName).usedRange
End Function

Function findArea(ByVal rng As Range) As Range
    rng.Select
    
    '�P�[�X��1���݂̂��`�F�b�N
    If Cells(rng.Row, rng.Column + 1).Value <> "" Then
        Selection.End(xlToRight).Select
    End If
    Set endCellAdress = Selection.End(xlDown)
       
    Set findArea = Range(rng, endCellAdress)
End Function

Function writingInAggregateTable(ByVal i As Integer, _
                                 ByVal count As Long, _
                                 ByVal aggregateTableName As String, _
                                 ByVal wsName As String, _
                                 ByVal toCellsInVariationRng As Range, _
                                 ByVal inputedexecutingDateCell As Range, _
                                 ByVal variationMaxNum As Integer)
        '�V�[�g�����Y���Z���ɓ���
        Worksheets(aggregateTableName).Cells(4 + i + count, 2) = wsName
        '�P�[�X�ԍ����Y���Z���ɓ���
        Worksheets(aggregateTableName).Cells(4 + i + count, 3) = i + 1
        '�Z���̗�ԍ��𐔎�����p��ɕϊ�
        columnId = columnNumberToAlphabet(toCellsInVariationRng.Column + i)
        '���s����\�����鐔�����Y���Z���ɓ���
        Worksheets(aggregateTableName).Cells(4 + i + count, 4) = "=TEXT(INDIRECT(B" & (4 + i + count) & "&" & """" & "!" & columnId & inputedexecutingDateCell.Row & """" & ")," & """" & "yyyy/mm/dd" & """" & ")"
        '�e�X�g�P�[�X�ɕR�Â�"��"�̐����J�E���g���鐔�����Y���Z���ɓ���
        Worksheets(aggregateTableName).Cells(4 + i + count, 5) = "=COUNTIF(INDIRECT(B" & (4 + i + count) & "&" & """" & "!" & columnId & toCellsInVariationRng.Row & ":" & columnId & (toCellsInVariationRng.Row + variationMaxNum - 1) & """" & ")," & """" & "��" & """" & ")"
        '�e�X�g�P�[�X�ɕR�Â�"��"�̐����J�E���g���鐔�����Y���Z���ɓ���
        Worksheets(aggregateTableName).Cells(4 + i + count, 6) = "=COUNTIF(INDIRECT(B" & (4 + i + count) & "&" & """" & "!" & columnId & toCellsInVariationRng.Row & ":" & columnId & (toCellsInVariationRng.Row + variationMaxNum - 1) & """" & ")," & """" & "��" & """" & ")"
        '�e�X�g�P�[�X�ɕR�Â��o���G�[�V���������v�����鐔�����Y���Z���ɓ���
        Worksheets(aggregateTableName).Cells(4 + i + count, 7) = "=SUM(E" & (4 + i + count) & ":F" & (4 + i + count) & ")"
End Function

Function isSameTestingSpecification(ByVal wb As String, ByVal ws As String, ByVal i As Integer) As Boolean
    Dim result As Boolean
    
    If Workbooks(wb).Sheets(ws).Cells(10 + i, 2).Value = Workbooks(wb).Sheets(ws).Cells(10 + i + 1, 2).Value Then
        result = True
    Else
        result = False
    End If
    
    isSameTestingSpecification = result
End Function

Function addNewWorksheets(ByVal wbName As String, ByVal wsName As String)
    Dim newWorkSheet As Worksheet
    Set newWorkSheet = Worksheets.add()
    newWorkSheet.Name = wsName
    Workbooks(wbName).Worksheets(wsName).Range("B3") = "�V�[�g��"
    Workbooks(wbName).Worksheets(wsName).Range("C3") = "�P�[�X�ԍ�"
    Workbooks(wbName).Worksheets(wsName).Range("D3") = "���s��"
    Workbooks(wbName).Worksheets(wsName).Range("E3") = "���̐�"
    Workbooks(wbName).Worksheets(wsName).Range("F3") = "���̐�"
    Workbooks(wbName).Worksheets(wsName).Range("G3") = "����"
End Function

Function isSheetDuplicationCheck(ByVal wsName As String) As Boolean
    Dim ws As Worksheet
    For Each ws In Worksheets
        If ws.Name = wsName Then isSheetDuplicationCheck = True
    Next ws
End Function