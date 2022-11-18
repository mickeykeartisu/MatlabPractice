%% class to calculate dynamic pattern matching by cepstrum
classdef DynamicPatternMatchingCepstrum < handle
    %% how to use : Usage
    %   1. generate AutocorrelationFunction instance
    %       -> arguments : 
    %           ・ signal    :   monoral signal numeric array
    %           ・ window_mode   :   window name
    %   2. if you'd like to calculate autocorrelation, conduct calculate_autocorrelation_with_fourier() method(recomended)
    %   3. if you'd like to calculate autocorrelation, conduct calculate_autocorrelation() method(not recomended)
    %   4. if you'd like to check properties, conduct display_properties() method

    %% ---------- properties ---------- %%
    properties(Access = public)
        x_file_path;
        y_file_path;
        order;
    end

     %% ---------- methods ---------- %%
    methods
        %% ---------- default constructor ---------- %%
        function object = DynamicPatternMatchingCepstrum(x_file_paht, y_file_path, order)
            switch nargin
                case 2
                    object.x_file_path = x_file_paht;
                    object.y_file_path = y_file_path;
                    object.order = 2;   % [ms]
                case 3
                    object.x_file_path = x_file_paht;
                    object.y_file_path = y_file_path;
                    object.order = order;
                otherwise
                    throw(MException("Constructor:arguments", "arguments is not adjust, please input 2 or 3 arguments."));
            end

            x_audio_file_manipulator = AudioFileManipulator(object.x_file_path);
            x_cepstrum = Cepstrum(x_audio_file_manipulator, x_audio_file_manipulator.sample_rate, "hamming", object.order);
            y_audio_file_manipulator = AudioFileManipulator(object.y_file_path);
            y_cepstrum = Cepstrum(y_audio_file_manipulator, y_audio_file_manipulator.sample_rate, "hamming", object.order);

            [dist, map, g] = dpMatch(x_cepstrum.cepstrum, y_cepstrum.cepstrum, 0, 0, 0.6);
            imagesc(min(g', 100)); axis xy; hold on;
            plot(map, 'w', 'LineWidth', 2);
        end

        %% ---------- setters ---------- %%
        % x_file_path setter
        function set.x_file_path(object, x_file_path)
            if strlength(x_file_path) < 1
                throw(MException("Setter:x_file_path", "x_file_path length is smaller than 1."));
            end
            object.x_file_path = x_file_path;
        end

        % y_file_path setter
        function set.y_file_path(object, y_file_path)
            if strlength(y_file_path) < 1
                throw(MException("Setter:y_file_path", "y_file_path length is smaller than 1."));
            end
            object.y_file_path = y_file_path;
        end

        % order setter
        function set.order(object, order)
            if order < 0
                throw(MException("Setter:order", "order is smaller than 0."));
            end
            object.order = order;
        end

        %% ---------- getters ---------- %%
        % x_file_path getter
        function x_file_path = get.x_file_path(object)
            x_file_path = object.x_file_path;
        end

        % y_file_path getter
        function y_file_path = get.y_file_path(object)
            y_file_path = object.y_file_path;
        end

        % order getter
        function order = get.order(object)
            order = object.order;
        end
        
        %% ---------- usual method ---------- %%
        % method to display properties
        function display_properties(object)
            fprintf("--------------------------------------------\n");
            fprintf("---- Dynamic Pattern Matching Cepstrum -----\n");
            fprintf("x_file_path : %s\n", object.x_file_path);
            fprintf("y_file_path : %s\n", object.y_file_path);
            fprintf("order : %s\n", object.order);
            fprintf("--------------------------------------------\n\n");
        end
    end
end