T = readtable("MAE205_FPData.xlsx",Range = 'B2:K33',ReadRowNames = false);
T2 = table2array(T);
Featurename = readtable("MAE205_FPData.xlsx", Range = 'B1:K1', ReadVariableNames = false);
featureNames = table2cell(Featurename);
USL = T2(1,:);
LSL = T2(2,:);
numFeatures = size(T2, 2);
Datapoints = T2(3:end, :);
Means = zeros(1, numFeatures);
Stds = zeros(1, numFeatures);

for ii = 1:numFeatures
    Means(ii) = mean(Datapoints(:, ii));
    Stds(ii) = std(Datapoints(:, ii));
    Cp(ii) = (USL(ii) - LSL(ii)) / (6 * Stds(ii));
    Cpk(ii) = min((USL(ii) - Means(ii)) / (3 * Stds(ii)), (Means(ii) - LSL(ii)) / (3 * Stds(ii)));
end

SummaryTable = table(char(featureNames(:)),USL(:),LSL(:),Means(:),Stds(:),'VariableNames', {'Feature', 'USL', 'LSL', 'Avg', 'Std. Dev'});
data_pull = questdlg('Which features do you want to analyze', 'Control Chart Data', 'All', 'Cp < 1.00', 'Custom', 'All');

disp(SummaryTable)


switch data_pull
    case 'All'
        selectedFeatures = featureNames;
    case 'Cp < 1.00'
        selectedFeatures = featureNames(Cp < 1.00);
    case 'Custom'
        Custom = inputdlg({'Enter Which features do you want to analyze, as an array'}, 'Features',[10 80], {featureNames{1}});
        selectedFeatures = strsplit(Custom{1}, ',');
    otherwise
        selectedFeatures = featureNames;
end

for ii = 1:length(selectedFeatures)
    featureIdx = find(strcmp(featureNames, selectedFeatures{ii}));
    data = Datapoints(:, featureIdx);
    title(sprintf('%s Process Control Data', selectedFeatures{ii}))
    mu = Means(featureIdx);
    sigma = Stds(featureIdx);
    usl = USL(featureIdx);
    lsl = LSL(featureIdx);
    x_data = data;
    run_data = 1:length(x_data);
    sgtitle(sprintf('Feature: %s Analysis', selectedFeatures{ii}));
    subplot(2,2,1)
    grid on
    x = linspace(mu - 4*sigma, mu + 4*sigma, 100);
    y = normpdf(x, mu, sigma);
    plot(x, y, 'b-', 'LineWidth', 1.5);
    hold on
    xline(usl, 'r--');
    xline(lsl, 'r--');
    title(sprintf('%s Process Control Data', selectedFeatures{ii}));
    xlabel('Range');
    ylabel('%');

    subplot(2,2,2)
    plot(run_data, x_data, 'bo-');
    hold on
    yline(usl, 'r--');
    yline(lsl, 'r--');
    title(sprintf('%s Process Control Data\nCp = %.2f, Cpk = %.2f', selectedFeatures{ii}, Cp(featureIdx), Cpk(featureIdx)));
    xlabel('Run Data');
    ylabel('Range');
    grid off;
    subplot(2,2,3)
    histogram(x_data)
    xline(usl, 'r--');
    xline(lsl, 'r--');
    title(sprintf('%s Process Control Data', selectedFeatures{ii}));
    xlabel('Range');
    ylabel('Qty.');
    grid on;

    subplot(2,2,4)
    scatter(run_data, x_data, 'b');
    hold on;
    p = polyfit(run_data', x_data, 1);
    y_fit = polyval(p, run_data);
    plot(run_data, y_fit, 'r-');

    xq = linspace(min(run_data), max(run_data));
    y_spline = spline(run_data, x_data, xq);
    plot(xq, y_spline, 'g--');
    title(sprintf('%s Process Control Data', selectedFeatures{ii}));
    xlabel('Run Data');
    ylabel('Range');
    grid on;
    exportgraphics(gcf, 'ArenasFinalProject.pdf', 'Width', 550, 'Height', 450, 'Append', true);
    clf;
end
close all