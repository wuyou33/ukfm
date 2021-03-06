t = linspace(0, dt*N, N);

f_rot = @(x) squeeze(sqrt(mean(x(1, :, :).^2, 3)));
f_p = @(x) squeeze(sqrt(mean(x(2, :, :).^2, 3)));

ukf_err_Rots = f_rot(ukf_errs);
ukf_err_ps = f_p(ukf_errs);
ukf_left_err_Rots = f_rot(ukf_left_errs);
ukf_left_err_ps = f_p(ukf_left_errs);
ukf_right_err_Rots = f_rot(ukf_right_errs);
ukf_right_err_ps = f_p(ukf_right_errs);
ekf_err_Rots = f_rot(ekf_errs);
ekf_err_ps = f_p(ekf_errs);
iekf_err_Rots = f_rot(iekf_errs);
iekf_err_ps = f_p(iekf_errs);

set(groot,'defaulttextinterprete','latex');  
set(groot, 'defaultAxesTickLabelInterprete','latex');  
set(groot, 'defaultLegendInterprete','latex');
cur_folder = pwd;
cur_folder = cur_folder(end-5:end);

fig1 = figure;
hold on;
grid on;
title('Robot position for a Monte-Carlo run')
xlabel('$x$ (m)')
ylabel('$y$ (m)')
plot(ps(:, 1), ps(:, 2), 'k', 'LineWidth', 1.5);
plot(ukf_ps(:, 1), ukf_ps(:, 2), 'm');
plot(ukf_left_ps(:, 1), ukf_left_ps(:, 2), 'g');
plot(ukf_right_ps(:, 1), ukf_right_ps(:, 2), 'c');
plot(ekf_ps(:, 1), ekf_ps(:, 2), 'r');
plot(iekf_ps(:, 1), iekf_ps(:, 2), 'b');
axis equal;
legend('true position', '$SO(2)$ UKF', '$SE(2)$ \textbf{left UKF}', ...
    '$SE(2)$ \textbf{right UKF}', 'EKF', 'IEKF [BB17]');

fig2 = figure;
title('Robot orientation error (deg)')
xlabel('$t$ (s)')
ylabel('orientation error (deg)')
hold on;
grid on;
plot(t, 180/pi*ukf_err_Rots, 'm');
plot(t, 180/pi*ukf_left_err_Rots, 'g');
plot(t, 180/pi*ukf_right_err_Rots, 'c');
plot(t, 180/pi*ekf_err_Rots, 'r');
plot(t, 180/pi*iekf_err_Rots, 'b');
legend('$SO(2)$ UKF', '$SE(2)$ \textbf{left UKF}', ...
    '$SE(2)$ \textbf{right UKF}', ...
    'EKF', 'IEKF [BB17]');

fig3 = figure;
title('Robot position error (m)')
xlabel('$t$ (s)')
ylabel('error (m)')
hold on;
grid on;
plot(t, ukf_err_ps, 'm');
plot(t, ukf_left_err_ps, 'g');
plot(t, ukf_right_err_ps, 'c');
plot(t, ekf_err_ps, 'r');
plot(t, iekf_err_ps, 'b');
legend('$SO(2)$ UKF', '$SE(2)$ \textbf{left UKF}', ...
    '$SE(2)$ \textbf{right UKF}', ...
    'EKF', 'IEKF [BB17]');

f_rot = @(x) sprintf('%0.2f', 180/pi*sqrt(mean(x.^2)));
f_p = @(x)  sprintf('%0.2f', sqrt(mean(x.^2)));
ukf_err_Rot = f_rot(ukf_err_Rots);
ukf_err_p = f_p(ukf_err_ps);
ukf_left_err_Rot = f_rot(ukf_left_err_Rots);
ukf_left_err_p = f_p(ukf_left_err_ps);
ukf_right_err_Rot = f_rot(ukf_right_err_Rots);
ukf_right_err_p = f_p(ukf_right_err_ps);
ekf_err_Rot = f_rot(ekf_err_Rots);
ekf_err_p = f_p(ekf_err_ps);
iekf_err_Rot = f_rot(iekf_err_Rots);
iekf_err_p = f_p(iekf_err_ps);

if cur_folder == "matlab"
    print(fig1, 'benchmarks/html/figures/benchmark_localization_01', ...
        '-dpng', '-r600')
    print(fig2, 'benchmarks/html/figures/benchmark_localization_02', ...
        '-dpng', '-r600')
    print(fig3, 'benchmarks/html/figures/benchmark_localization_03', ...
        '-dpng', '-r600')
end
disp(' ')
disp('Root Mean Square Error w.r.t. orientation (deg)');
disp("    -SO(2) x R^2 UKF: " + ukf_err_Rot);
disp("    -left SE(2) UKF : " + ukf_left_err_Rot);
disp("    -right SE(2) UKF: " + ukf_right_err_Rot);
disp("    -EKF            : " + ekf_err_Rot);
disp("    -IEKF           : " + iekf_err_Rot);

disp(' ')
disp('Root Mean Square Error w.r.t. position (m)');
disp("    -SO(2) x R^2 UKF: " + ukf_err_p);
disp("    -left SE(2) UKF : " + ukf_left_err_p);
disp("    -right SE(2) UKF: " + ukf_right_err_p);
disp("    -EKF            : " + ekf_err_p);
disp("    -IEKF           : " + iekf_err_p);
