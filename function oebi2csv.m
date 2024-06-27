function oebi2csv(rows, stim_duration_sec, fs, r1, r2, output_csv)
    % 필수 설정 확인
    if nargin < 6
        error('모든 입력 인자가 필요합니다.');
    end

    % 인수의 데이터 유형 확인 및 변환
    rows = double(rows);
    stim_duration_sec = double(stim_duration_sec);
    fs = double(fs);

    % oebin 파일 불러오기
    try
        D = load_open_ephys_binary(r1, 'continuous', 1, 'mmap');
        SD = D.Data.Data.mapped;
        SSD = SD(rows, :); % 바이너리 데이터 저장
    catch ME
        disp('oebin 파일을 불러오는 중 오류가 발생했습니다.');
        rethrow(ME);
    end

    % 이벤트 타임스탬프 읽기
    try
        TS1 = readNPY(r2);
        TS2 = TS1 * fs;
        TS = round(TS2);
        stim_ignore = stim_duration_sec * fs;
    catch ME
        disp('NPY 파일을 읽는 중 오류가 발생했습니다.');
        rethrow(ME);
    end

    % US 자극 중 첫번째만 남기기
    index = 1; % 시작 인덱스
    slicedData = []; % 슬라이스된 데이터 저장 배열
    while index <= length(TS)
        currentData = TS(index); % 현재 데이터
        slicedData = [slicedData; currentData]; % 슬라이스된 데이터 추가
        nextIndex = find(TS > currentData + stim_ignore, 1); % 현재 데이터보다 stim_ignore 이상 큰 다음 데이터 찾기
        if isempty(nextIndex) % 더 이상 찾을 수 없으면 종료
            break;
        else % 찾으면 다음 루프에서 그 위치부터 시작
            index = nextIndex;
        end
    end

    % slicedData가 SSD의 열 범위 내에 있는지 확인하고 조정
    validIndices = slicedData <= size(SSD, 2);
    slicedData = slicedData(validIndices);

    % 이벤트 행 생성 (slicedData 위치에 1, 그 외 위치에 0) - 희소 행렬 사용
    eventRow = sparse(1, slicedData, 1, 1, size(SSD, 2));

    % 희소 행렬을 일반 배열로 변환하고 검사
    fullEventRow = full(eventRow);

    % SSD 데이터와 eventRow를 결합
    combinedData = vertcat(SSD, fullEventRow);

    % 데이터 형식 확인
    disp('SSD 데이터 형식:');
    disp(class(SSD));
    disp(size(SSD));
    disp('Event Row:');
    disp(fullEventRow); % 실제로 이벤트가 기록된 위치 출력
    disp('combinedData 데이터 형식:');
    disp(class(combinedData));
    disp(size(combinedData));
    disp('combinedData 내용:');
    disp(combinedData(:, 1:10)); % 첫 10개의 열만 출력

    % 결합된 데이터를 CSV 파일로 저장
    try
        writematrix(combinedData', output_csv);
        disp('CSV 파일 저장 성공');
    catch ME
        disp('CSV 파일을 저장하는 중 오류가 발생했습니다.');
        rethrow(ME);
    end
end

